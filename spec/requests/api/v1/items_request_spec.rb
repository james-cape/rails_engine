require 'rails_helper'

describe "Items API" do
  it "sends a list of items" do
    merchant_1 = create(:merchant)
    # customer_1 = create(:customer)
    # invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
    #
    # create_list(:transaction, 3, invoice: invoice_1)
    create_list(:item, 3, merchant: merchant_1)

    get '/api/v1/items'

    expect(response).to be_successful
    items = JSON.parse(response.body)
    expect(items.count).to eq(3)
  end
end
