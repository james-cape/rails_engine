require 'rails_helper'

describe "Merchants API" do
  it "sends a list of merchants" do
    create_list(:merchant, 3)

    get '/api/v1/merchants.json'

    expect(response).to be_successful
    merchants = JSON.parse(response.body)
    expect(merchants["data"].count).to eq(3)
  end

  it "can get one merchant by id" do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}.json"

    merchant = JSON.parse(response.body)
    expect(response).to be_successful
    expect(merchant["data"]["id"].to_i).to eq(id)
  end

  it "gets all of a merchant's items" do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)

    item_1 = create(:item, merchant: merchant_1)
    item_2 = create(:item, merchant: merchant_1)
    item_3 = create(:item, merchant: merchant_1)
    item_4 = create(:item, merchant: merchant_2)

    get "/api/v1/merchants/#{merchant_1.id}/items"

    items = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    assert_equal 3, items.count
    assert_equal item_1.id, items[0]["id"].to_i
    assert_equal item_2.id, items[1]["id"].to_i
    assert_equal item_3.id, items[2]["id"].to_i
  end

  it "gets all of a merchant's invoices" do
    customer_1 = create(:customer)
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)

    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_3 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_4 = create(:invoice, merchant: merchant_2, customer: customer_1)

    get "/api/v1/merchants/#{merchant_1.id}/invoices"

    invoices = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    assert_equal 3, invoices.count
    assert_equal invoice_1.id, invoices[0]["id"].to_i
    assert_equal invoice_2.id, invoices[1]["id"].to_i
    assert_equal invoice_3.id, invoices[2]["id"].to_i
  end
end
