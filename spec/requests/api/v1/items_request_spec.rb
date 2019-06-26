require 'rails_helper'

describe "Items API" do
  it "sends a list of items" do
    merchant_1 = create(:merchant)
    create_list(:item, 3, merchant: merchant_1)

    get '/api/v1/items.json'

    expect(response).to be_successful
    items = JSON.parse(response.body)
    expect(items["data"].count).to eq(3)
  end

  it "gets item by id" do
    merchant_1 = create(:merchant)
    id = create(:item, merchant: merchant_1).id

    get "/api/v1/items/#{id}.json"

    expect(response).to be_successful
    item = JSON.parse(response.body)
    expect(item["data"]["id"].to_i).to eq(id)
  end

  it "gets all of an item's invoice_items" do
    customer_1 = create(:customer)
    merchant_1 = create(:merchant)

    item_1 = create(:item, merchant: merchant_1)
    item_2 = create(:item, merchant: merchant_1)
    item_3 = create(:item, merchant: merchant_1)
    item_4 = create(:item, merchant: merchant_1)

    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_item_1 = create(:invoice_item, invoice: invoice_1, item: item_1)
    invoice_item_2 = create(:invoice_item, invoice: invoice_1, item: item_1)
    invoice_item_3 = create(:invoice_item, invoice: invoice_1, item: item_2)

    invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_item_4 = create(:invoice_item, invoice: invoice_2, item: item_3)
    invoice_item_5 = create(:invoice_item, invoice: invoice_2, item: item_4)
    invoice_item_6 = create(:invoice_item, invoice: invoice_2, item: item_1)

    get "/api/v1/items/#{item_1.id}/invoice_items"

    invoice_items = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    assert_equal 3, invoice_items.count
    assert_equal invoice_item_1.id, invoice_items[0]["id"].to_i
    assert_equal invoice_item_2.id, invoice_items[1]["id"].to_i
    assert_equal invoice_item_6.id, invoice_items[2]["id"].to_i
  end

  it "gets an item's merchant" do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)

    item_1 = create(:item, merchant: merchant_1)
    item_2 = create(:item, merchant: merchant_2)

    get "/api/v1/items/#{item_1.id}/merchant"

    merchant = JSON.parse(response.body)
    expect(response).to be_successful
    assert_equal 1, merchant.count
    assert_equal merchant_1.id, merchant["data"]["id"].to_i
  end
end
