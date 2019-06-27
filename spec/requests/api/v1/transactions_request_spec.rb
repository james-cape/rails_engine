require 'rails_helper'

describe "Transactions API" do
  it "sends a list of transactions" do
    merchant_1 = create(:merchant)
    customer_1 = create(:customer)
    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)

    create_list(:transaction, 3, invoice: invoice_1)

    get '/api/v1/transactions.json'

    expect(response).to be_successful
    transactions = JSON.parse(response.body)
    expect(transactions["data"].count).to eq(3)
  end

  it "gets transaction by id" do
    merchant_1 = create(:merchant)
    customer_1 = create(:customer)
    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)

    id = create(:transaction, invoice: invoice_1).id

    get "/api/v1/transactions/#{id}.json"

    transaction = JSON.parse(response.body)
    expect(response).to be_successful
    expect(transaction["data"]["id"].to_i).to eq(id)
  end

  it "gets a transaction's invoice" do
    merchant_1 = create(:merchant)

    customer_1 = create(:customer)
    invoice_1 = create(:invoice, customer: customer_1, merchant: merchant_1)
    invoice_2 = create(:invoice, customer: customer_1, merchant: merchant_1)
    transaction_1 = create(:transaction, invoice: invoice_1)
    transaction_2 = create(:transaction, invoice: invoice_2)

    get "/api/v1/transactions/#{transaction_1.id}/invoice"
    
    invoice = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    assert_instance_of Hash, invoice
    assert_equal invoice_1.id, invoice["id"].to_i
  end
end
