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

    invoice_items_unsorted = JSON.parse(response.body)["data"]
    invoice_items_sorted = invoice_items_unsorted.sort_by { |element| element["id"] }

    expect(response).to be_successful
    expect(invoice_items_sorted.count).to eq(3)
    expect(invoice_items_sorted[0]["id"].to_i).to eq(invoice_item_1.id)
    expect(invoice_items_sorted[1]["id"].to_i).to eq(invoice_item_2.id)
    expect(invoice_items_sorted[2]["id"].to_i).to eq(invoice_item_6.id)
  end

  it "gets an item's merchant" do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)

    item_1 = create(:item, merchant: merchant_1)
    item_2 = create(:item, merchant: merchant_2)

    get "/api/v1/items/#{item_1.id}/merchant"

    merchant = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    expect(merchant.class).to eq(Hash)
    expect(merchant["id"].to_i).to eq(merchant_1.id)
  end

  it "gets item by id" do
    merchant_1 = create(:merchant)

    item_1 = create(:item, merchant: merchant_1)
    item_2 = create(:item, merchant: merchant_1)
    item_3 = create(:item, merchant: merchant_1)

    get "/api/v1/items/find?id=#{item_1.id}"

    item = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    expect(item.class).to eq(Hash)
    expect(item["attributes"]["id"].to_i).to eq(item_1.id)
  end

  it "gets item by name" do
    merchant_1 = create(:merchant)

    item_1 = create(:item, merchant: merchant_1, name: "name_1")
    item_2 = create(:item, merchant: merchant_1, name: "name_2")
    item_3 = create(:item, merchant: merchant_1, name: "name_3")

    get "/api/v1/items/find?name=#{item_1.name}"

    item = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    expect(item.class).to eq(Hash)
    expect(item["attributes"]["name"]).to eq(item_1.name)
  end

  it "gets item by description" do
    merchant_1 = create(:merchant)

    item_1 = create(:item, merchant: merchant_1, description: "description_1")
    item_2 = create(:item, merchant: merchant_1, description: "description_2")
    item_3 = create(:item, merchant: merchant_1, description: "description_3")

    get "/api/v1/items/find?description=#{item_1.description}"

    item = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    expect(item.class).to eq(Hash)
    expect(item["attributes"]["description"]).to eq(item_1.description)
  end

  it "gets item by unit_price" do
    merchant_1 = create(:merchant)

    item_1 = create(:item, merchant: merchant_1, unit_price: "23445")
    item_2 = create(:item, merchant: merchant_1, unit_price: "74747")
    item_3 = create(:item, merchant: merchant_1, unit_price: "90234")
    test_price = "234.45"

    get "/api/v1/items/find?unit_price=#{test_price}"

    item = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    expect(item.class).to eq(Hash)
    expect(item["attributes"]["unit_price"]).to eq((item_1.unit_price.to_f / 100).to_s)
  end

  it "gets item by merchant_id" do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    merchant_3 = create(:merchant)

    item_1 = create(:item, merchant: merchant_1)
    item_2 = create(:item, merchant: merchant_2)
    item_3 = create(:item, merchant: merchant_3)

    get "/api/v1/items/find?merchant_id=#{item_1.merchant_id}"

    item = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    expect(item.class).to eq(Hash)
    expect(item["attributes"]["merchant_id"]).to eq(item_1.merchant_id)
  end

  it "gets item by created_at" do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    merchant_3 = create(:merchant)

    item_1 = create(:item, merchant: merchant_1, created_at: "2012-03-27T14:54:05.000Z")
    item_2 = create(:item, merchant: merchant_2, created_at: "2012-04-27T14:54:05.000Z")
    item_3 = create(:item, merchant: merchant_3, created_at: "2012-05-27T14:54:05.000Z")

    get "/api/v1/items/find?created_at=#{item_2.created_at}"

    item = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    expect(item.class).to eq(Hash)
    expect(item["attributes"]["id"]).to eq(item_2.id)
  end

  it "gets item by updated_at" do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    merchant_3 = create(:merchant)

    item_1 = create(:item, merchant: merchant_1, updated_at: "2012-03-27T14:54:04.000Z")
    item_2 = create(:item, merchant: merchant_2, updated_at: "2012-03-27T14:54:05.000Z")
    item_3 = create(:item, merchant: merchant_3, updated_at: "2012-03-27T14:54:06.000Z")

    get "/api/v1/items/find?updated_at=#{item_2.updated_at}"

    item = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    expect(item.class).to eq(Hash)
    expect(item["attributes"]["id"]).to eq(item_2.id)
  end

  it "gets all items by id" do
    merchant_1 = create(:merchant)

    item_1 = create(:item, merchant: merchant_1)
    item_2 = create(:item, merchant: merchant_1)
    item_3 = create(:item, merchant: merchant_1)

    get "/api/v1/items/find_all?id=#{item_1.id}"

    item = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    expect(item.count).to eq(1)
    expect(item[0]["attributes"]["id"].to_i).to eq(item_1.id)
  end

  it "gets all items by name" do
    merchant_1 = create(:merchant)

    item_1 = create(:item, merchant: merchant_1, name: "name_1")
    item_2 = create(:item, merchant: merchant_1, name: "name_1")
    item_3 = create(:item, merchant: merchant_1, name: "name_2")

    get "/api/v1/items/find_all?name=#{item_1.name}"

    item = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    expect(item.count).to eq(2)
    expect(item[0]["attributes"]["name"]).to eq(item_1.name)
    expect(item[1]["attributes"]["name"]).to eq(item_1.name)
  end

  it "gets all items by description" do
    merchant_1 = create(:merchant)

    item_1 = create(:item, merchant: merchant_1, description: "description_1")
    item_2 = create(:item, merchant: merchant_1, description: "description_1")
    item_3 = create(:item, merchant: merchant_1, description: "description_2")

    get "/api/v1/items/find_all?description=#{item_1.description}"

    item = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    expect(item.count).to eq(2)
    expect(item[0]["attributes"]["description"]).to eq(item_1.description)
    expect(item[1]["attributes"]["description"]).to eq(item_1.description)
  end

  it "gets all items by unit_price" do
    merchant_1 = create(:merchant)

    item_1 = create(:item, merchant: merchant_1, unit_price: "23445")
    item_2 = create(:item, merchant: merchant_1, unit_price: "23445")
    item_3 = create(:item, merchant: merchant_1, unit_price: "14563")
    test_price = "234.45"

    get "/api/v1/items/find_all?unit_price=#{test_price}"

    item = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    expect(item.count).to eq(2)
    expect(item[0]["attributes"]["unit_price"]).to eq((item_1.unit_price.to_f / 100).to_s)
    expect(item[1]["attributes"]["unit_price"]).to eq((item_1.unit_price.to_f / 100).to_s)
  end

  it "gets all items by merchant_id" do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)

    item_1 = create(:item, merchant: merchant_1)
    item_2 = create(:item, merchant: merchant_1)
    item_3 = create(:item, merchant: merchant_2)

    get "/api/v1/items/find_all?merchant_id=#{item_1.merchant_id}"

    item = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    expect(item.count).to eq(2)
    expect(item[0]["attributes"]["merchant_id"]).to eq(item_1.merchant_id)
    expect(item[1]["attributes"]["merchant_id"]).to eq(item_1.merchant_id)
  end

  it "gets all items by created_at" do
    merchant_1 = create(:merchant)

    item_1 = create(:item, merchant: merchant_1, created_at: "2012-03-27T14:54:05.000Z")
    item_2 = create(:item, merchant: merchant_1, created_at: "2012-03-27T14:54:05.000Z")
    item_3 = create(:item, merchant: merchant_1, created_at: "2012-05-27T14:54:05.000Z")

    get "/api/v1/items/find_all?created_at=#{item_1.created_at}"

    item = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    expect(item.count).to eq(2)
    expect(item[0]["attributes"]["id"]).to eq(item_1.id)
    expect(item[1]["attributes"]["id"]).to eq(item_2.id)
  end

  it "gets all items by updated_at" do
    merchant_1 = create(:merchant)

    item_1 = create(:item, merchant: merchant_1, updated_at: "2012-03-27T14:54:05.000Z")
    item_2 = create(:item, merchant: merchant_1, updated_at: "2012-03-27T14:54:05.000Z")
    item_3 = create(:item, merchant: merchant_1, updated_at: "2012-05-27T14:54:05.000Z")

    get "/api/v1/items/find_all?updated_at=#{item_1.updated_at}"

    item = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    expect(item.count).to eq(2)
    expect(item[0]["attributes"]["id"]).to eq(item_1.id)
    expect(item[1]["attributes"]["id"]).to eq(item_2.id)
  end

  it "gets a random item" do
    merchant_1 = create(:merchant)

    item_1 = create(:item, merchant: merchant_1)
    item_2 = create(:item, merchant: merchant_1)
    item_3 = create(:item, merchant: merchant_1)
    item_4 = create(:item, merchant: merchant_1)

    get "/api/v1/items/random"

    random_item = JSON.parse(response.body)["data"]
    expect(Item.find(random_item["attributes"]["id"])).to be_in([item_1, item_2, item_3, item_4])
  end
end
