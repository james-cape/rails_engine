require 'rails_helper'

describe "Invoices API" do
  it "sends a list of invoices" do
    customer_1 = create(:customer)
    merchant_1 = create(:merchant)
    create_list(:invoice, 3, customer: customer_1, merchant: merchant_1)

    get '/api/v1/invoices.json'

    expect(response).to be_successful
    invoices = JSON.parse(response.body)
    expect(invoices["data"].count).to eq(3)
  end

  it "gets invoice by id" do
    customer_1 = create(:customer)
    merchant_1 = create(:merchant)
    id = create(:invoice, customer: customer_1, merchant: merchant_1).id

    get "/api/v1/invoices/#{id}.json"

    expect(response).to be_successful
    invoice = JSON.parse(response.body)
    expect(invoice["data"]["id"].to_i).to eq(id)
  end

  it "gets all of an invoice's transactions" do
    customer_1 = create(:customer)
    merchant_1 = create(:merchant)
    item_1 = create(:item, merchant: merchant_1)

    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_1)

    transaction_1 = create(:transaction, invoice: invoice_1)
    transaction_2 = create(:transaction, invoice: invoice_1)
    transaction_3 = create(:transaction, invoice: invoice_1)
    transaction_4 = create(:transaction, invoice: invoice_2)
    transaction_5 = create(:transaction, invoice: invoice_2)

    get "/api/v1/invoices/#{invoice_1.id}/transactions"

    transactions = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    assert_equal 3, transactions.count
    assert_equal transaction_1.id, transactions[0]["id"].to_i
    assert_equal transaction_2.id, transactions[1]["id"].to_i
    assert_equal transaction_3.id, transactions[2]["id"].to_i
  end

  it "gets all of an invoice's items" do
    customer_1 = create(:customer)
    merchant_1 = create(:merchant)

    item_1 = create(:item, merchant: merchant_1)
    item_2 = create(:item, merchant: merchant_1)
    item_3 = create(:item, merchant: merchant_1)
    item_4 = create(:item, merchant: merchant_1)

    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
    create(:invoice_item, invoice: invoice_1, item: item_1)
    create(:invoice_item, invoice: invoice_1, item: item_2)
    create(:invoice_item, invoice: invoice_1, item: item_2)

    invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_1)
    create(:invoice_item, invoice: invoice_2, item: item_3)
    create(:invoice_item, invoice: invoice_2, item: item_3)
    create(:invoice_item, invoice: invoice_2, item: item_4)

    get "/api/v1/invoices/#{invoice_1.id}/items"

    items = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    assert_equal 3, items.count
    assert_equal item_1.id, items[0]["id"].to_i
    assert_equal item_2.id, items[1]["id"].to_i
    assert_equal item_2.id, items[2]["id"].to_i
  end

  it "gets all of an invoice's invoice_items" do
    customer_1 = create(:customer)
    merchant_1 = create(:merchant)

    item_1 = create(:item, merchant: merchant_1)
    item_2 = create(:item, merchant: merchant_1)
    item_3 = create(:item, merchant: merchant_1)
    item_4 = create(:item, merchant: merchant_1)

    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_item_1 = create(:invoice_item, invoice: invoice_1, item: item_1)
    invoice_item_2 = create(:invoice_item, invoice: invoice_1, item: item_2)
    invoice_item_3 = create(:invoice_item, invoice: invoice_1, item: item_2)

    invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_item_4 = create(:invoice_item, invoice: invoice_2, item: item_3)
    invoice_item_5 = create(:invoice_item, invoice: invoice_2, item: item_3)
    invoice_item_6 = create(:invoice_item, invoice: invoice_2, item: item_4)

    get "/api/v1/invoices/#{invoice_1.id}/invoice_items"

    invoice_items = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    assert_equal 3, invoice_items.count
    assert_equal invoice_item_1.id, invoice_items[0]["id"].to_i
    assert_equal invoice_item_2.id, invoice_items[1]["id"].to_i
    assert_equal invoice_item_3.id, invoice_items[2]["id"].to_i
  end

  it "gets an invoice's customer" do
    customer_1 = create(:customer)
    customer_2 = create(:customer)
    merchant_1 = create(:merchant)

    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_2)

    get "/api/v1/invoices/#{invoice_1.id}/customer"

    customer = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    assert_instance_of Hash, customer
    assert_equal customer_1.id, customer["id"].to_i
  end

  it "gets an invoice's merchant" do
    customer_1 = create(:customer)
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)

    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_2 = create(:invoice, merchant: merchant_2, customer: customer_1)

    get "/api/v1/invoices/#{invoice_1.id}/merchant"

    merchant = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    assert_instance_of Hash, merchant
    assert_equal merchant_1.id, merchant["id"].to_i
  end

  it "gets revenue for all successful transactions by date" do
    customer_1 = create(:customer)
    merchant_1 = create(:merchant)

    item_1 = create(:item, merchant: merchant_1)

    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1, updated_at: "2012-03-27 14:54:10 UTC")
    invoice_item_1 = create(:invoice_item, invoice: invoice_1, item: item_1, unit_price: 305, quantity: 3)
    invoice_item_2 = create(:invoice_item, invoice: invoice_1, item: item_1, unit_price: 305, quantity: 3)
    invoice_item_3 = create(:invoice_item, invoice: invoice_1, item: item_1, unit_price: 305, quantity: 3)

    invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_1, updated_at: "2012-03-26 14:54:10 UTC")
    invoice_item_4 = create(:invoice_item, invoice: invoice_2, item: item_1, unit_price: 305, quantity: 3)
    invoice_item_5 = create(:invoice_item, invoice: invoice_2, item: item_1, unit_price: 305, quantity: 3)
    invoice_item_6 = create(:invoice_item, invoice: invoice_2, item: item_1, unit_price: 305, quantity: 3)

    invoice_3 = create(:invoice, merchant: merchant_1, customer: customer_1, updated_at: "2012-03-27 14:54:10 UTC")
    invoice_item_7 = create(:invoice_item, invoice: invoice_2, item: item_1, unit_price: 305, quantity: 3)
    invoice_item_8 = create(:invoice_item, invoice: invoice_2, item: item_1, unit_price: 305, quantity: 3)
    invoice_item_9 = create(:invoice_item, invoice: invoice_2, item: item_1, unit_price: 305, quantity: 3)

    transaction_1 = create(:transaction, invoice: invoice_1, result: "success")
    transaction_2 = create(:transaction, invoice: invoice_2, result: "success")
    transaction_3 = create(:transaction, invoice: invoice_3, result: "failed")

    revenue_1 = (invoice_item_1.quantity * invoice_item_1.unit_price)
    revenue_2 = (invoice_item_2.quantity * invoice_item_2.unit_price)
    revenue_3 = (invoice_item_3.quantity * invoice_item_3.unit_price)
    expected_revenue = ((revenue_1 + revenue_2 + revenue_3).to_f/100).to_s

    date = "2012-03-27"

    get "/api/v1/merchants/revenue?date=#{date}"

    actual_revenue = JSON.parse(response.body)["data"]["attributes"]["total_revenue"]
    expect(response).to be_successful
    assert_equal expected_revenue, actual_revenue
  end
end
