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
end
