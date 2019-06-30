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

  it "gets a merchant's favorite customer by succussful transactions" do
    customer_1 = create(:customer)
    customer_2 = create(:customer)
    customer_3 = create(:customer)
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)

    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_3 = create(:invoice, merchant: merchant_1, customer: customer_2)
    invoice_4 = create(:invoice, merchant: merchant_1, customer: customer_3)
    invoice_5 = create(:invoice, merchant: merchant_1, customer: customer_3)
    invoice_6 = create(:invoice, merchant: merchant_1, customer: customer_3)
    invoice_7 = create(:invoice, merchant: merchant_2, customer: customer_2)

    create(:transaction, invoice: invoice_1, result: "success")
    create(:transaction, invoice: invoice_2, result: "success")
    create(:transaction, invoice: invoice_3, result: "success")
    create(:transaction, invoice: invoice_4, result: "failed")
    create(:transaction, invoice: invoice_5, result: "failed")
    create(:transaction, invoice: invoice_6, result: "failed")
    create(:transaction, invoice: invoice_7, result: "success")

    get "/api/v1/merchants/#{merchant_1.id}/favorite_customer"

    favorite_customer = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    assert_instance_of Hash, favorite_customer
    assert_equal customer_1.id, favorite_customer["id"].to_i
  end

  it "gets item by id" do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    merchant_3 = create(:merchant)

    get "/api/v1/merchants/find?id=#{merchant_1.id}"

    merchant = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    expect(merchant.class).to eq(Hash)
    expect(merchant["attributes"]["id"].to_i).to eq(merchant_1.id)
  end

  it "gets item by name" do
    merchant_1 = create(:merchant, name: "name_1")
    merchant_2 = create(:merchant, name: "name_2")
    merchant_3 = create(:merchant, name: "name_3")

    get "/api/v1/merchants/find?name=#{merchant_1.name}"

    merchant = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    expect(merchant.class).to eq(Hash)
    expect(merchant["attributes"]["name"]).to eq(merchant_1.name)
  end

  it "gets item by created_at" do
    merchant_1 = create(:merchant, created_at: "2012-03-27T14:54:05.000Z")
    merchant_2 = create(:merchant, created_at: "2012-04-27T14:54:05.000Z")
    merchant_3 = create(:merchant, created_at: "2012-05-27T14:54:05.000Z")

    get "/api/v1/merchants/find?created_at=#{merchant_1.created_at}"

    merchant = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    expect(merchant.class).to eq(Hash)
    expect(merchant["attributes"]["id"]).to eq(merchant_1.id)
  end

  it "gets item by created_at" do
    merchant_1 = create(:merchant, created_at: "2012-03-27T14:54:05.000Z")
    merchant_2 = create(:merchant, created_at: "2012-04-27T14:54:05.000Z")
    merchant_3 = create(:merchant, created_at: "2012-05-27T14:54:05.000Z")

    get "/api/v1/merchants/find?created_at=#{merchant_1.created_at}"

    merchant = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    expect(merchant.class).to eq(Hash)
    expect(merchant["attributes"]["id"]).to eq(merchant_1.id)
  end

  it "gets all items by id" do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    merchant_3 = create(:merchant)

    get "/api/v1/merchants/find_all?id=#{merchant_1.id}"

    merchant = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    expect(merchant.class).to eq(Array)
    expect(merchant[0]["attributes"]["id"].to_i).to eq(merchant_1.id)
  end

  it "gets all items by name" do
    merchant_1 = create(:merchant, name: "name_1")
    merchant_2 = create(:merchant, name: "name_1")
    merchant_3 = create(:merchant, name: "name_2")

    get "/api/v1/merchants/find_all?name=#{merchant_1.name}"

    merchant = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    expect(merchant.count).to eq(2)
    expect(merchant[0]["attributes"]["id"]).to eq(merchant_1.id)
    expect(merchant[1]["attributes"]["id"]).to eq(merchant_2.id)
  end

  it "gets all items by created_at" do
    merchant_1 = create(:merchant, created_at: "2012-03-27T14:54:05.000Z")
    merchant_2 = create(:merchant, created_at: "2012-03-27T14:54:05.000Z")
    merchant_3 = create(:merchant, created_at: "2012-05-27T14:54:05.000Z")

    get "/api/v1/merchants/find_all?created_at=#{merchant_1.created_at}"

    merchant = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    expect(merchant.count).to eq(2)
    expect(merchant[0]["attributes"]["id"]).to eq(merchant_1.id)
    expect(merchant[1]["attributes"]["id"]).to eq(merchant_2.id)
  end

  it "gets all items by updated_at" do
    merchant_1 = create(:merchant, updated_at: "2012-03-27T14:54:05.000Z")
    merchant_2 = create(:merchant, updated_at: "2012-03-27T14:54:05.000Z")
    merchant_3 = create(:merchant, updated_at: "2012-05-27T14:54:05.000Z")

    get "/api/v1/merchants/find_all?updated_at=#{merchant_1.updated_at}"

    merchant = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    expect(merchant.count).to eq(2)
    expect(merchant[0]["attributes"]["id"]).to eq(merchant_1.id)
    expect(merchant[1]["attributes"]["id"]).to eq(merchant_2.id)
  end

  it "gets transaction revenue for a certain merchant by date" do
    customer_1 = create(:customer)
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)

    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1, updated_at: "2012-03-27T14:54:05.000Z")
    invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_1, updated_at: "2012-03-27T14:54:05.000Z")
    invoice_3 = create(:invoice, merchant: merchant_1, customer: customer_1, updated_at: "2013-03-27T14:54:05.000Z")
    invoice_4 = create(:invoice, merchant: merchant_2, customer: customer_1, updated_at: "2012-03-27T14:54:05.000Z")
    invoice_5 = create(:invoice, merchant: merchant_1, customer: customer_1, updated_at: "2012-03-27T14:54:05.000Z")

    create(:transaction, invoice: invoice_1, result: "success")
    create(:transaction, invoice: invoice_2, result: "success")
    create(:transaction, invoice: invoice_3, result: "success")
    create(:transaction, invoice: invoice_4, result: "success")
    create(:transaction, invoice: invoice_5, result: "failed")

    item_1 = create(:item, merchant: merchant_1)

    invoice_item_1 = create(:invoice_item, invoice: invoice_1, item: item_1, quantity: 5, unit_price: 100)
    invoice_item_2 = create(:invoice_item, invoice: invoice_2, item: item_1, quantity: 5, unit_price: 100)
    invoice_item_3 = create(:invoice_item, invoice: invoice_3, item: item_1, quantity: 5, unit_price: 100)
    invoice_item_4 = create(:invoice_item, invoice: invoice_4, item: item_1, quantity: 5, unit_price: 100)
    invoice_item_5 = create(:invoice_item, invoice: invoice_5, item: item_1, quantity: 5, unit_price: 100)

    date = "2012-03-27"
    get "/api/v1/merchants/#{merchant_1.id}/revenue?date=#{date}"

    merchant_revenue = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    expect(merchant_revenue.class).to eq(Hash)
    expect(merchant_revenue["attributes"]["revenue"]).to eq("10.00")
  end

  it "gets transaction revenue for a certain merchant for all dates" do
    customer_1 = create(:customer)
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)

    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1, updated_at: "2012-03-27T14:54:05.000Z")
    invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_1, updated_at: "2012-03-27T14:54:05.000Z")
    invoice_3 = create(:invoice, merchant: merchant_1, customer: customer_1, updated_at: "2013-03-27T14:54:05.000Z")
    invoice_4 = create(:invoice, merchant: merchant_2, customer: customer_1, updated_at: "2012-03-27T14:54:05.000Z")
    invoice_5 = create(:invoice, merchant: merchant_1, customer: customer_1, updated_at: "2012-03-27T14:54:05.000Z")

    create(:transaction, invoice: invoice_1, result: "success")
    create(:transaction, invoice: invoice_2, result: "success")
    create(:transaction, invoice: invoice_3, result: "success")
    create(:transaction, invoice: invoice_4, result: "success")
    create(:transaction, invoice: invoice_5, result: "failed")

    item_1 = create(:item, merchant: merchant_1)

    invoice_item_1 = create(:invoice_item, invoice: invoice_1, item: item_1, quantity: 5, unit_price: 100)
    invoice_item_2 = create(:invoice_item, invoice: invoice_2, item: item_1, quantity: 5, unit_price: 100)
    invoice_item_3 = create(:invoice_item, invoice: invoice_3, item: item_1, quantity: 5, unit_price: 100)
    invoice_item_4 = create(:invoice_item, invoice: invoice_4, item: item_1, quantity: 5, unit_price: 100)
    invoice_item_5 = create(:invoice_item, invoice: invoice_5, item: item_1, quantity: 5, unit_price: 100)

    get "/api/v1/merchants/#{merchant_1.id}/revenue"

    merchant_revenue = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    expect(merchant_revenue.class).to eq(Hash)
    expect(merchant_revenue["attributes"]["revenue"]).to eq("15.00")
  end

  it "gets a random merchant" do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    merchant_3 = create(:merchant)
    merchant_4 = create(:merchant)

    get "/api/v1/merchants/random"

    random_merchant = JSON.parse(response.body)["data"]
    expect(Merchant.find(random_merchant["attributes"]["id"])).to be_in([merchant_1, merchant_2, merchant_3, merchant_4])
  end
end
