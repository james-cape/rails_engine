require 'rails_helper'

describe "Customers API" do
  it "sends a list of customers" do
    create_list(:customer, 3)

    get '/api/v1/customers'

    expect(response).to be_successful

    customers = JSON.parse(response.body)
    expect(customers["data"].count).to eq(3)
  end

  it "gets a customer by id" do
    id = create(:customer).id

    get "/api/v1/customers/#{id}.json"

    customer = JSON.parse(response.body)
    expect(response).to be_successful
    expect(customer["data"]["id"].to_i).to eq(id)
  end

  it "gets a single customer's invoices" do
    merchant_1 = create(:merchant)

    customer_1 = create(:customer)
    invoice_1 = create(:invoice, customer: customer_1, merchant: merchant_1)
    invoice_2 = create(:invoice, customer: customer_1, merchant: merchant_1)

    customer_2 = create(:customer)
    invoice_3 = create(:invoice, customer: customer_2, merchant: merchant_1)
    invoice_4 = create(:invoice, customer: customer_2, merchant: merchant_1)

    get "/api/v1/customers/#{customer_1.id}/invoices"

    invoices = JSON.parse(response.body)
    expect(response).to be_successful
    expect(invoices["data"].count).to eq(2)
    expect(invoices["data"][0]["id"].to_i).to eq(invoice_1.id)
    expect(invoices["data"][1]["id"].to_i).to eq(invoice_2.id)
  end

  it "gets a single customer's transactions" do
    merchant_1 = create(:merchant)

    customer_1 = create(:customer)
    invoice_1 = create(:invoice, customer: customer_1, merchant: merchant_1)
    invoice_2 = create(:invoice, customer: customer_1, merchant: merchant_1)
    transaction_1 = create(:transaction, invoice: invoice_1)
    transaction_2 = create(:transaction, invoice: invoice_2)

    customer_2 = create(:customer)
    invoice_3 = create(:invoice, customer: customer_2, merchant: merchant_1)
    invoice_4 = create(:invoice, customer: customer_2, merchant: merchant_1)
    transaction_3 = create(:transaction, invoice: invoice_3)
    transaction_4 = create(:transaction, invoice: invoice_4)

    get "/api/v1/customers/#{customer_1.id}/transactions"

    transactions = JSON.parse(response.body)
    expect(response).to be_successful
    expect(transactions["data"].count).to eq(2)
    expect(transactions["data"][0]["id"].to_i).to eq(transaction_1.id)
    expect(transactions["data"][1]["id"].to_i).to eq(transaction_2.id)
  end

  it "finds customer by id" do
    customer_1 = create(:customer)
    customer_2 = create(:customer)
    customer_3 = create(:customer)

    get "/api/v1/customers/find?id=#{customer_1.id}"

    customer = JSON.parse(response.body)["data"]["attributes"]

    expect(response).to be_successful
    expect(customer["id"]).to eq(customer_1.id)
  end

  it "finds customer by first_name" do
    customer_1 = create(:customer, first_name: "name_1")
    customer_2 = create(:customer, first_name: "name_2")
    customer_3 = create(:customer, first_name: "name_3")

    get "/api/v1/customers/find?first_name=#{customer_1.first_name}"

    customer = JSON.parse(response.body)["data"]["attributes"]

    expect(response).to be_successful
    expect(customer["first_name"]).to eq(customer_1.first_name)
  end

  it "finds customer by last_name" do
    customer_1 = create(:customer, last_name: "name_1")
    customer_2 = create(:customer, last_name: "name_2")
    customer_3 = create(:customer, last_name: "name_3")

    get "/api/v1/customers/find?last_name=#{customer_1.last_name}"

    customer = JSON.parse(response.body)["data"]["attributes"]

    expect(response).to be_successful
    expect(customer["last_name"]).to eq(customer_1.last_name)
  end

  it "finds customer by created_at" do
    customer_1 = create(:customer, created_at: "2014-03-27 14:54:12 UTC")
    customer_2 = create(:customer, created_at: "2015-03-28 14:54:12 UTC")
    customer_3 = create(:customer, created_at: "2014-03-27 14:55:12 UTC")

    get "/api/v1/customers/find?created_at=#{customer_3.created_at}"

    customer = JSON.parse(response.body)["data"]["attributes"]

    expect(response).to be_successful
    expect(customer["id"]).to eq(customer_3.id)
  end

  it "finds customer by updated_at" do
    customer_1 = create(:customer, updated_at: "2014-03-27 14:54:12 UTC")
    customer_2 = create(:customer, updated_at: "2015-03-28 14:54:12 UTC")
    customer_3 = create(:customer, updated_at: "2014-03-27 14:55:12 UTC")

    get "/api/v1/customers/find?updated_at=#{customer_3.updated_at}"

    customer = JSON.parse(response.body)["data"]["attributes"]

    expect(response).to be_successful
    expect(customer["id"]).to eq(customer_3.id)
  end

  it "finds all customers by id" do
    customer_1 = create(:customer)
    customer_2 = create(:customer)
    customer_3 = create(:customer)

    get "/api/v1/customers/find_all?id=#{customer_1.id}"

    customers = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    expect(customers.count).to eq(1)
    expect(customers[0]["attributes"]["id"]).to eq(customer_1.id)
  end

  it "finds all customers by first_name" do
    customer_1 = create(:customer, first_name: "name_1")
    customer_2 = create(:customer, first_name: "name_1")
    customer_3 = create(:customer, first_name: "name_3")

    get "/api/v1/customers/find_all?first_name=#{customer_1.first_name}"

    customers = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    expect(customers.count).to eq(2)
    expect(customers[0]["attributes"]["first_name"]).to eq(customer_1.first_name)
    expect(customers[1]["attributes"]["first_name"]).to eq(customer_1.first_name)
  end

  it "finds all customers by last_name" do
    customer_1 = create(:customer, last_name: "name_1")
    customer_2 = create(:customer, last_name: "name_3")
    customer_3 = create(:customer, last_name: "name_3")

    get "/api/v1/customers/find_all?last_name=#{customer_3.last_name}"

    customers = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    expect(customers.count).to eq(2)
    expect(customers[0]["attributes"]["last_name"]).to eq(customer_3.last_name)
    expect(customers[1]["attributes"]["last_name"]).to eq(customer_3.last_name)
  end

  it "finds all customers by last_name" do
    customer_1 = create(:customer, last_name: "name_1")
    customer_2 = create(:customer, last_name: "name_3")
    customer_3 = create(:customer, last_name: "name_3")

    get "/api/v1/customers/find_all?last_name=#{customer_3.last_name}"

    customers = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    expect(customers.count).to eq(2)
    expect(customers[0]["attributes"]["last_name"]).to eq(customer_3.last_name)
    expect(customers[1]["attributes"]["last_name"]).to eq(customer_3.last_name)
  end

  it "finds all customers by created_at" do
    customer_1 = create(:customer, created_at: "2014-03-27 14:54:12 UTC")
    customer_2 = create(:customer, created_at: "2014-03-27 14:54:12 UTC")
    customer_3 = create(:customer, created_at: "2014-03-27 12:54:12 UTC")

    get "/api/v1/customers/find_all?created_at=#{customer_2.created_at}"

    customers = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    expect(customers.count).to eq(2)
    expect(customers[0]["attributes"]["id"]).to eq(customer_1.id)
    expect(customers[1]["attributes"]["id"]).to eq(customer_2.id)
  end

  it "finds all customers by updated_at" do
    customer_1 = create(:customer, updated_at: "2014-03-27 14:54:12 UTC")
    customer_2 = create(:customer, updated_at: "2014-03-27 14:54:12 UTC")
    customer_3 = create(:customer, updated_at: "2014-03-27 12:54:12 UTC")

    get "/api/v1/customers/find_all?updated_at=#{customer_2.updated_at}"

    customers = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    expect(customers.count).to eq(2)
    expect(customers[0]["attributes"]["id"]).to eq(customer_1.id)
    expect(customers[1]["attributes"]["id"]).to eq(customer_2.id)
  end

  it "gets a random customer" do
    customer_1 = create(:customer)
    customer_2 = create(:customer)
    customer_3 = create(:customer)
    customer_4 = create(:customer)

    get "/api/v1/customers/random"

    random_customer = JSON.parse(response.body)["data"]
    expect(Customer.find(random_customer["attributes"]["id"])).to be_in([customer_1, customer_2, customer_3, customer_4])
  end
end
