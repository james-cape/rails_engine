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

end
