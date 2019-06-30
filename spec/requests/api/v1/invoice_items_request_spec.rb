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

    invoice = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    expect(invoice.class).to eq(Hash)
    expect(invoice["id"].to_i).to eq(invoice_1.id)
  end

  it "finds invoice_item by id" do
    customer_1 = create(:customer)
    merchant_1 = create(:merchant)
    item_1 = create(:item, merchant: merchant_1)

    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_item_1 = create(:invoice_item, invoice: invoice_1, item: item_1)

    invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_item_2 = create(:invoice_item, invoice: invoice_2, item: item_1)

    get "/api/v1/invoice_items/find?id=#{invoice_item_1.id}"

    invoice_item = JSON.parse(response.body)["data"]["attributes"]
    expect(response).to be_successful
    expect(invoice_item.class).to eq(Hash)
    expect(invoice_item["id"]).to eq(invoice_item_1.id)
  end

  it "finds invoice_item by item_id" do
    customer_1 = create(:customer)
    merchant_1 = create(:merchant)
    item_1 = create(:item, merchant: merchant_1)

    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_item_1 = create(:invoice_item, invoice: invoice_1, item: item_1)

    invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_item_2 = create(:invoice_item, invoice: invoice_2, item: item_1)

    get "/api/v1/invoice_items/find?item_id=#{invoice_item_1.item_id}"

    invoice_item = JSON.parse(response.body)["data"]["attributes"]
    expect(response).to be_successful
    expect(invoice_item.class).to eq(Hash)
    expect(invoice_item["item_id"]).to eq(invoice_item_1.item_id)
  end

  it "finds invoice_item by invoice_id" do
    customer_1 = create(:customer)
    merchant_1 = create(:merchant)
    item_1 = create(:item, merchant: merchant_1)

    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_item_1 = create(:invoice_item, invoice: invoice_1, item: item_1)

    invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_item_2 = create(:invoice_item, invoice: invoice_2, item: item_1)

    get "/api/v1/invoice_items/find?invoice_id=#{invoice_item_1.invoice_id}"

    invoice_item = JSON.parse(response.body)["data"]["attributes"]
    expect(response).to be_successful
    expect(invoice_item.class).to eq(Hash)
    expect(invoice_item["invoice_id"]).to eq(invoice_item_1.invoice_id)
  end

  it "finds invoice_item by quantity" do
    customer_1 = create(:customer)
    merchant_1 = create(:merchant)
    item_1 = create(:item, merchant: merchant_1)

    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_item_1 = create(:invoice_item, invoice: invoice_1, item: item_1, quantity: 2)

    invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_item_2 = create(:invoice_item, invoice: invoice_2, item: item_1, quantity: 1)

    get "/api/v1/invoice_items/find?quantity=#{invoice_item_1.quantity}"

    invoice_item = JSON.parse(response.body)["data"]["attributes"]
    expect(response).to be_successful
    expect(invoice_item.class).to eq(Hash)
    expect(invoice_item["quantity"]).to eq(invoice_item_1.quantity)
  end

  it "finds invoice_item by unit_price" do
    customer_1 = create(:customer)
    merchant_1 = create(:merchant)
    item_1 = create(:item, merchant: merchant_1)

    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_item_1 = create(:invoice_item, invoice: invoice_1, item: item_1, unit_price: 23445)

    invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_item_2 = create(:invoice_item, invoice: invoice_2, item: item_1, unit_price: 15888)
    test_price = "234.45"
    get "/api/v1/invoice_items/find?unit_price=#{test_price}"

    invoice_item = JSON.parse(response.body)["data"]["attributes"]
    expect(response).to be_successful
    expect(invoice_item.class).to eq(Hash)
    expect(invoice_item["unit_price"]).to eq((invoice_item_1.unit_price.to_f / 100).to_s)
  end

  it "finds invoice_item by created_at" do
    customer_1 = create(:customer)
    merchant_1 = create(:merchant)
    item_1 = create(:item, merchant: merchant_1)

    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_item_1 = create(:invoice_item, invoice: invoice_1, item: item_1, created_at: "2014-03-27 14:54:12 UTC")

    invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_item_2 = create(:invoice_item, invoice: invoice_2, item: item_1, created_at: "2014-05-27 14:54:12 UTC")

    get "/api/v1/invoice_items/find?created_at=#{invoice_item_1.created_at}"

    invoice_item = JSON.parse(response.body)["data"]["attributes"]
    expect(response).to be_successful
    expect(invoice_item.class).to eq(Hash)
    expect(invoice_item["id"]).to eq(invoice_item_1.id)
  end

  it "finds invoice_item by updated_at" do
    customer_1 = create(:customer)
    merchant_1 = create(:merchant)
    item_1 = create(:item, merchant: merchant_1)

    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_item_1 = create(:invoice_item, invoice: invoice_1, item: item_1, updated_at: "2014-03-27 14:54:12 UTC")

    invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_item_2 = create(:invoice_item, invoice: invoice_2, item: item_1, updated_at: "2014-05-27 14:54:12 UTC")

    get "/api/v1/invoice_items/find?updated_at=#{invoice_item_1.updated_at}"

    invoice_item = JSON.parse(response.body)["data"]["attributes"]
    expect(response).to be_successful
    expect(invoice_item.class).to eq(Hash)
    expect(invoice_item["id"]).to eq(invoice_item_1.id)
  end

  it "finds all invoice_items by id" do
    customer_1 = create(:customer)
    merchant_1 = create(:merchant)
    item_1 = create(:item, merchant: merchant_1)

    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_item_1 = create(:invoice_item, invoice: invoice_1, item: item_1)

    invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_item_2 = create(:invoice_item, invoice: invoice_2, item: item_1)

    invoice_3 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_item_3 = create(:invoice_item, invoice: invoice_3, item: item_1)

    get "/api/v1/invoice_items/find_all?id=#{invoice_item_1.id}"
    invoice_items = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    expect(invoice_items[0]["attributes"]["id"]).to eq(invoice_item_1.id)
  end

  it "finds all invoice_items by item_id" do
    customer_1 = create(:customer)
    merchant_1 = create(:merchant)
    item_1 = create(:item, merchant: merchant_1)
    item_2 = create(:item, merchant: merchant_1)

    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_item_1 = create(:invoice_item, invoice: invoice_1, item: item_1)

    invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_item_2 = create(:invoice_item, invoice: invoice_2, item: item_1)

    invoice_3 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_item_3 = create(:invoice_item, invoice: invoice_3, item: item_2)

    get "/api/v1/invoice_items/find_all?item_id=#{invoice_item_1.item_id}"
    invoice_items = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    expect(invoice_items.count).to eq(2)
    expect(invoice_items[0]["attributes"]["item_id"]).to eq(invoice_item_1.item_id)
    expect(invoice_items[1]["attributes"]["item_id"]).to eq(invoice_item_1.item_id)
  end

  it "finds all invoice_items by invoice_id" do
    customer_1 = create(:customer)
    merchant_1 = create(:merchant)
    item_1 = create(:item, merchant: merchant_1)
    item_2 = create(:item, merchant: merchant_1)

    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_1)

    invoice_item_1 = create(:invoice_item, invoice: invoice_1, item: item_1)
    invoice_item_2 = create(:invoice_item, invoice: invoice_1, item: item_1)
    invoice_item_3 = create(:invoice_item, invoice: invoice_2, item: item_2)

    get "/api/v1/invoice_items/find_all?invoice_id=#{invoice_item_1.invoice_id}"
    invoice_items = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    expect(invoice_items.count).to eq(2)
    expect(invoice_items[0]["attributes"]["invoice_id"]).to eq(invoice_item_1.invoice_id)
    expect(invoice_items[1]["attributes"]["invoice_id"]).to eq(invoice_item_1.invoice_id)
  end

  it "finds all invoice_items by quantity" do
    customer_1 = create(:customer)
    merchant_1 = create(:merchant)
    item_1 = create(:item, merchant: merchant_1)
    item_2 = create(:item, merchant: merchant_1)

    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_1)

    invoice_item_1 = create(:invoice_item, invoice: invoice_1, item: item_1, quantity: 1)
    invoice_item_2 = create(:invoice_item, invoice: invoice_1, item: item_1, quantity: 1)
    invoice_item_3 = create(:invoice_item, invoice: invoice_2, item: item_2, quantity: 2)

    get "/api/v1/invoice_items/find_all?quantity=#{invoice_item_1.quantity}"
    invoice_items = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    expect(invoice_items.count).to eq(2)
    expect(invoice_items[0]["attributes"]["quantity"]).to eq(invoice_item_1.quantity)
    expect(invoice_items[1]["attributes"]["quantity"]).to eq(invoice_item_1.quantity)
  end

  it "finds all invoice_items by unit_price" do
    customer_1 = create(:customer)
    merchant_1 = create(:merchant)
    item_1 = create(:item, merchant: merchant_1)
    item_2 = create(:item, merchant: merchant_1)

    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_1)

    invoice_item_1 = create(:invoice_item, invoice: invoice_1, item: item_1, unit_price: 10505)
    invoice_item_2 = create(:invoice_item, invoice: invoice_1, item: item_1, unit_price: 10505)
    invoice_item_3 = create(:invoice_item, invoice: invoice_2, item: item_2, unit_price: 20505)
    test_price = "105.05"

    get "/api/v1/invoice_items/find_all?unit_price=#{test_price}"
    invoice_items = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    expect(invoice_items.count).to eq(2)
    expect(invoice_items[0]["attributes"]["unit_price"]).to eq((invoice_item_1.unit_price.to_f / 100).to_s)
    expect(invoice_items[1]["attributes"]["unit_price"]).to eq((invoice_item_1.unit_price.to_f / 100).to_s)
  end

  it "finds all invoice_items by created_at" do
    customer_1 = create(:customer)
    merchant_1 = create(:merchant)
    item_1 = create(:item, merchant: merchant_1)
    item_2 = create(:item, merchant: merchant_1)

    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_1)

    invoice_item_1 = create(:invoice_item, invoice: invoice_1, item: item_1, created_at: "2014-03-27 14:54:12 UTC")
    invoice_item_2 = create(:invoice_item, invoice: invoice_1, item: item_1, created_at: "2014-03-27 14:54:12 UTC")
    invoice_item_3 = create(:invoice_item, invoice: invoice_2, item: item_2, created_at: "2014-03-17 14:54:12 UTC")

    get "/api/v1/invoice_items/find_all?created_at=#{invoice_item_1.created_at}"
    invoice_items = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    expect(invoice_items.count).to eq(2)
    expect(invoice_items[0]["attributes"]["id"]).to eq(invoice_item_1.id)
    expect(invoice_items[1]["attributes"]["id"]).to eq(invoice_item_2.id)
  end

  it "finds all invoice_items by updated_at" do
    customer_1 = create(:customer)
    merchant_1 = create(:merchant)
    item_1 = create(:item, merchant: merchant_1)
    item_2 = create(:item, merchant: merchant_1)

    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_1)

    invoice_item_1 = create(:invoice_item, invoice: invoice_1, item: item_1, updated_at: "2014-03-27 14:54:12 UTC")
    invoice_item_2 = create(:invoice_item, invoice: invoice_1, item: item_1, updated_at: "2014-03-27 14:54:12 UTC")
    invoice_item_3 = create(:invoice_item, invoice: invoice_2, item: item_2, updated_at: "2014-03-17 14:54:12 UTC")

    get "/api/v1/invoice_items/find_all?updated_at=#{invoice_item_1.updated_at}"
    invoice_items = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    expect(invoice_items.count).to eq(2)
    expect(invoice_items[0]["attributes"]["id"]).to eq(invoice_item_1.id)
    expect(invoice_items[1]["attributes"]["id"]).to eq(invoice_item_2.id)
  end

  it "gets a random invoice_item" do
    customer_1 = create(:customer)
    merchant_1 = create(:merchant)
    item_1 = create(:item, merchant: merchant_1)

    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)

    invoice_item_1 = create(:invoice_item, invoice: invoice_1, item: item_1)
    invoice_item_2 = create(:invoice_item, invoice: invoice_1, item: item_1)
    invoice_item_3 = create(:invoice_item, invoice: invoice_1, item: item_1)
    invoice_item_4 = create(:invoice_item, invoice: invoice_1, item: item_1)

    get "/api/v1/invoice_items/random"

    random_invoice_item = JSON.parse(response.body)["data"]
    expect(InvoiceItem.find(random_invoice_item["attributes"]["id"])).to be_in([invoice_item_1, invoice_item_2, invoice_item_3, invoice_item_4])
  end
end
