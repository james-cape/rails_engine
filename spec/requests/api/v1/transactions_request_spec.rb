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

  it "gets a transaction by id" do
    merchant_1 = create(:merchant)
    customer_1 = create(:customer)
    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)

    transaction_1 = create(:transaction, invoice: invoice_1)
    transaction_2 = create(:transaction, invoice: invoice_1)
    transaction_3 = create(:transaction, invoice: invoice_1)

    get "/api/v1/transactions/find?id=#{transaction_1.id}"

    transaction = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    expect(transaction.class).to eq(Hash)
    expect(transaction["attributes"]["id"].to_i).to eq(transaction_1.id)
  end

  it "gets a transaction by invoice_id" do
    merchant_1 = create(:merchant)
    customer_1 = create(:customer)
    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_3 = create(:invoice, merchant: merchant_1, customer: customer_1)

    transaction_1 = create(:transaction, invoice: invoice_1)
    transaction_2 = create(:transaction, invoice: invoice_2)
    transaction_3 = create(:transaction, invoice: invoice_3)

    get "/api/v1/transactions/find?invoice_id=#{transaction_1.invoice_id}"

    transaction = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    expect(transaction.class).to eq(Hash)
    expect(transaction["attributes"]["id"].to_i).to eq(transaction_1.id)
  end

  it "gets a transaction by credit_card_number" do
    merchant_1 = create(:merchant)
    customer_1 = create(:customer)
    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)

    transaction_1 = create(:transaction, invoice: invoice_1, credit_card_number: "4654405418249632")
    transaction_2 = create(:transaction, invoice: invoice_1, credit_card_number: "5654405418249632")
    transaction_3 = create(:transaction, invoice: invoice_1, credit_card_number: "6654405418249632")

    get "/api/v1/transactions/find?credit_card_number=#{transaction_1.credit_card_number}"

    transaction = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    expect(transaction.class).to eq(Hash)
    expect(transaction["attributes"]["id"].to_i).to eq(transaction_1.id)
  end

  it "gets a transaction by result" do
    merchant_1 = create(:merchant)
    customer_1 = create(:customer)
    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)

    transaction_1 = create(:transaction, invoice: invoice_1, result: "success")
    transaction_2 = create(:transaction, invoice: invoice_1, result: "failed")
    transaction_3 = create(:transaction, invoice: invoice_1, result: "failed")

    get "/api/v1/transactions/find?result=#{transaction_1.result}"

    transaction = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    expect(transaction.class).to eq(Hash)
    expect(transaction["attributes"]["id"].to_i).to eq(transaction_1.id)
  end

  it "gets a transaction by created_at" do
    merchant_1 = create(:merchant)
    customer_1 = create(:customer)
    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)

    transaction_1 = create(:transaction, invoice: invoice_1, created_at: "2012-03-27T14:54:57.000Z")
    transaction_2 = create(:transaction, invoice: invoice_1, created_at: "2013-03-27T14:54:57.000Z")
    transaction_3 = create(:transaction, invoice: invoice_1, created_at: "2014-03-27T14:54:57.000Z")

    get "/api/v1/transactions/find?created_at=#{transaction_1.created_at}"

    transaction = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    expect(transaction.class).to eq(Hash)
    expect(transaction["attributes"]["id"].to_i).to eq(transaction_1.id)
  end

  it "gets a transaction by updated_at" do
    merchant_1 = create(:merchant)
    customer_1 = create(:customer)
    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)

    transaction_1 = create(:transaction, invoice: invoice_1, updated_at: "2012-03-27T14:54:57.000Z")
    transaction_2 = create(:transaction, invoice: invoice_1, updated_at: "2013-03-27T14:54:57.000Z")
    transaction_3 = create(:transaction, invoice: invoice_1, updated_at: "2014-03-27T14:54:57.000Z")

    get "/api/v1/transactions/find?updated_at=#{transaction_1.updated_at}"

    transaction = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    expect(transaction.class).to eq(Hash)
    expect(transaction["attributes"]["id"].to_i).to eq(transaction_1.id)
  end

  it "gets all transactions by id" do
    merchant_1 = create(:merchant)
    customer_1 = create(:customer)
    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)

    transaction_1 = create(:transaction, invoice: invoice_1)
    transaction_2 = create(:transaction, invoice: invoice_1)
    transaction_3 = create(:transaction, invoice: invoice_1)

    get "/api/v1/transactions/find_all?id=#{transaction_1.id}"

    transaction = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    expect(transaction.class).to eq(Array)
    expect(transaction[0]["attributes"]["id"].to_i).to eq(transaction_1.id)
  end

  it "gets all transactions by invoice_id" do
    merchant_1 = create(:merchant)
    customer_1 = create(:customer)
    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_1)

    transaction_1 = create(:transaction, invoice: invoice_1)
    transaction_2 = create(:transaction, invoice: invoice_1)
    transaction_3 = create(:transaction, invoice: invoice_2)

    get "/api/v1/transactions/find_all?invoice_id=#{transaction_1.invoice_id}"

    transaction = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    expect(transaction.count).to eq(2)
    expect(transaction[0]["attributes"]["id"].to_i).to eq(transaction_1.id)
    expect(transaction[1]["attributes"]["id"].to_i).to eq(transaction_2.id)
  end

  it "gets all transactions by credit_card_number" do
    merchant_1 = create(:merchant)
    customer_1 = create(:customer)
    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_1)

    transaction_1 = create(:transaction, invoice: invoice_1, credit_card_number: "4654405418249632")
    transaction_2 = create(:transaction, invoice: invoice_1, credit_card_number: "4654405418249632")
    transaction_3 = create(:transaction, invoice: invoice_1, credit_card_number: "6654405418249632")

    get "/api/v1/transactions/find_all?credit_card_number=#{transaction_1.credit_card_number}"

    transaction = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    expect(transaction.count).to eq(2)
    expect(transaction[0]["attributes"]["id"].to_i).to eq(transaction_1.id)
    expect(transaction[1]["attributes"]["id"].to_i).to eq(transaction_2.id)
  end

  it "gets all transactions by result" do
    merchant_1 = create(:merchant)
    customer_1 = create(:customer)
    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_1)

    transaction_1 = create(:transaction, invoice: invoice_1, result: "success")
    transaction_2 = create(:transaction, invoice: invoice_1, result: "success")
    transaction_3 = create(:transaction, invoice: invoice_1, result: "failed")

    get "/api/v1/transactions/find_all?result=#{transaction_1.result}"

    transaction = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    expect(transaction.count).to eq(2)
    expect(transaction[0]["attributes"]["id"].to_i).to eq(transaction_1.id)
    expect(transaction[1]["attributes"]["id"].to_i).to eq(transaction_2.id)
  end

  it "gets all transactions by created_at" do
    merchant_1 = create(:merchant)
    customer_1 = create(:customer)
    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_1)

    transaction_1 = create(:transaction, invoice: invoice_1, created_at: "2012-03-27T14:54:57.000Z")
    transaction_2 = create(:transaction, invoice: invoice_1, created_at: "2012-03-27T14:54:57.000Z")
    transaction_3 = create(:transaction, invoice: invoice_1, created_at: "2014-03-27T14:54:57.000Z")

    get "/api/v1/transactions/find_all?created_at=#{transaction_1.created_at}"

    transaction = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    expect(transaction.count).to eq(2)
    expect(transaction[0]["attributes"]["id"].to_i).to eq(transaction_1.id)
    expect(transaction[1]["attributes"]["id"].to_i).to eq(transaction_2.id)
  end

  it "gets all transactions by updated_at" do
    merchant_1 = create(:merchant)
    customer_1 = create(:customer)
    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
    invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_1)

    transaction_1 = create(:transaction, invoice: invoice_1, updated_at: "2012-03-27T14:54:57.000Z")
    transaction_2 = create(:transaction, invoice: invoice_1, updated_at: "2012-03-27T14:54:57.000Z")
    transaction_3 = create(:transaction, invoice: invoice_1, updated_at: "2014-03-27T14:54:57.000Z")

    get "/api/v1/transactions/find_all?updated_at=#{transaction_1.updated_at}"

    transaction = JSON.parse(response.body)["data"]
    expect(response).to be_successful
    expect(transaction.count).to eq(2)
    expect(transaction[0]["attributes"]["id"].to_i).to eq(transaction_1.id)
    expect(transaction[1]["attributes"]["id"].to_i).to eq(transaction_2.id)
  end

  it "gets a random transaction" do
    merchant_1 = create(:merchant)
    customer_1 = create(:customer)
    invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)

    transaction_1 = create(:transaction, invoice: invoice_1)
    transaction_2 = create(:transaction, invoice: invoice_1)
    transaction_3 = create(:transaction, invoice: invoice_1)
    transaction_4 = create(:transaction, invoice: invoice_1)

    get "/api/v1/transactions/random"

    random_transaction = JSON.parse(response.body)["data"]
    expect(Transaction.find(random_transaction["attributes"]["id"])).to be_in([transaction_1, transaction_2, transaction_3, transaction_4])
  end
end
