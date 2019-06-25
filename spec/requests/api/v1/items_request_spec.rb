require 'rails_helper'

describe "Items API" do
  it "sends a list of items" do
    merchant_1 = create(:merchant)
    create_list(:item, 3, merchant: merchant_1)

    get '/api/v1/items.json'

    expect(response).to be_successful
    items = JSON.parse(response.body)
    expect(items["data"].count).to eq(3)
  end

  it "gets item by id" do
    merchant_1 = create(:merchant)
    id = create(:item, merchant: merchant_1).id

    get "/api/v1/items/#{id}.json"

    expect(response).to be_successful
    item = JSON.parse(response.body)
    expect(item["data"]["id"].to_i).to eq(id)
  end
end
