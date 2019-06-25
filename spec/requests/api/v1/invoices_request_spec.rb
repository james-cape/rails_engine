require 'rails_helper'

describe "Invoices API" do
  it "sends a list of invoices" do
    customer_1 = create(:customer)
    merchant_1 = create(:merchant)
    create_list(:invoice, 3, customer: customer_1, merchant: merchant_1)

    get '/api/v1/invoices'

    expect(response).to be_successful
    invoices = JSON.parse(response.body)
    expect(invoices.count).to eq(3)
  end
end
