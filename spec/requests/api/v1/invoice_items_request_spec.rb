require 'rails_helper'

describe "Invoice_items API" do
  it "sends a list of invoice_items" do
    customer_1 = create(:customer)
    merchant_1 = create(:merchant)

    invoice_1 = create(:invoice, customer: customer_1, merchant: merchant_1)
    invoice_2 = create(:invoice, customer: customer_1, merchant: merchant_1)
    invoice_3 = create(:invoice, customer: customer_1, merchant: merchant_1)

    item_1 = create(:item, merchant: merchant_1)
    item_2 = create(:item, merchant: merchant_1)
    item_3 = create(:item, merchant: merchant_1)

    invoice_item_1 = create(:invoice_item, invoice: invoice_1, item: item_1)
    invoice_item_2 = create(:invoice_item, invoice: invoice_2, item: item_2)
    invoice_item_3 = create(:invoice_item, invoice: invoice_3, item: item_3)

    get '/api/v1/invoice_items.json'

    expect(response).to be_successful
    invoice_items = JSON.parse(response.body)
    expect(invoice_items["data"].count).to eq(3)
  end

  it "gets invoice_item by id" do
    customer_1 = create(:customer)
    merchant_1 = create(:merchant)
    invoice_1 = create(:invoice, customer: customer_1, merchant: merchant_1)
    item_1 = create(:item, merchant: merchant_1)
    id = create(:invoice_item, invoice: invoice_1, item: item_1).id

    get "/api/v1/invoice_items/#{id}"

    invoice_item = JSON.parse(response.body)
    expect(response).to be_successful
    expect(invoice_item["data"]["id"].to_i).to eq(id)
  end

  it "gets a single invoice_item's invoice" do
    customer_1 = create(:customer)
    merchant_1 = create(:merchant)
    item_1 = create(:item, merchant: merchant_1)

    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_item_1 = create(:invoice_item, invoice: invoice_1, item: item_1)

    invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_item_2 = create(:invoice_item, invoice: invoice_2, item: item_1)

    get "/api/v1/invoice_items/#{invoice_item_1.id}/invoice"

    invoice = JSON.parse(response.body)
    expect(response).to be_successful
    assert_equal 1, invoice.count
    assert_equal invoice_1.id, invoice["data"]["id"].to_i
  end

  it "gets a single invoice_item's item" do
    customer_1 = create(:customer)
    merchant_1 = create(:merchant)
    item_1 = create(:item, merchant: merchant_1)

    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_item_1 = create(:invoice_item, invoice: invoice_1, item: item_1)

    invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_item_2 = create(:invoice_item, invoice: invoice_2, item: item_1)

    get "/api/v1/invoice_items/#{invoice_item_1.id}/item"

    item = JSON.parse(response.body)
    expect(response).to be_successful
    assert_equal 1, item.count
    assert_equal item_1.id, item["data"]["id"].to_i
  end
end
