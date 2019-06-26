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
    assert_equal invoices["data"].count, 2
    assert_equal invoices["data"][0]["id"].to_i, invoice_1.id
    assert_equal invoices["data"][1]["id"].to_i, invoice_2.id
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
    assert_equal transactions["data"].count, 2
    assert_equal transactions["data"][0]["id"].to_i, transaction_1.id
    assert_equal transactions["data"][1]["id"].to_i, transaction_2.id
  end
end
