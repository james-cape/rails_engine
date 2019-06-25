require 'rails_helper'

describe "Transactions API" do
  it "sends a list of transactions" do
    merchant_1 = create(:merchant)
    customer_1 = create(:customer)
    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)

    create_list(:transaction, 3, invoice: invoice_1)

    get '/api/v1/transactions'

    expect(response).to be_successful
    transactions = JSON.parse(response.body)
    expect(transactions.count).to eq(3)
  end
end
