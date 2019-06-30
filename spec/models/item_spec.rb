require 'rails_helper'

RSpec.describe Item, type: :model do
  describe "relationships" do
    it {should belong_to :merchant}
    it {should have_many :invoice_items}
  end

  describe "methods" do
    it "returns best day by invoice creation for a given item by successful transactions" do
      customer_1 = create(:customer)
      merchant_1 = create(:merchant)

      item_1 = create(:item, merchant: merchant_1)
      item_2 = create(:item, merchant: merchant_1)
      item_3 = create(:item, merchant: merchant_1)

      invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1, created_at: "2012-04-23")
      create(:invoice_item, invoice: invoice_1, item: item_1, quantity: 1)
      create(:invoice_item, invoice: invoice_1, item: item_2, quantity: 2)
      create(:invoice_item, invoice: invoice_1, item: item_3, quantity: 5)

      invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_1, created_at: "2012-04-24")
      create(:invoice_item, invoice: invoice_2, item: item_1, quantity: 4)
      create(:invoice_item, invoice: invoice_2, item: item_2, quantity: 4)
      create(:invoice_item, invoice: invoice_2, item: item_3, quantity: 4)

      invoice_3 = create(:invoice, merchant: merchant_1, customer: customer_1, created_at: "2012-04-25")
      create(:invoice_item, invoice: invoice_3, item: item_1, quantity: 3)
      create(:invoice_item, invoice: invoice_3, item: item_2, quantity: 3)
      create(:invoice_item, invoice: invoice_3, item: item_3, quantity: 3)

      expect(item_1.find_best_day.best_day).to eq("2012-04-24".to_datetime)
      expect(item_2.find_best_day.best_day).to eq("2012-04-24".to_datetime)
      expect(item_3.find_best_day.best_day).to eq("2012-04-23".to_datetime)
    end

    it "returns variable number of top items sold by quantity" do
      customer_1 = create(:customer)
      merchant_1 = create(:merchant)

      item_1 = create(:item, merchant: merchant_1)
      item_2 = create(:item, merchant: merchant_1)
      item_3 = create(:item, merchant: merchant_1)

      invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1, created_at: "2012-04-23")
      create(:invoice_item, invoice: invoice_1, item: item_1, quantity: 1, unit_price: 12345)
      create(:invoice_item, invoice: invoice_1, item: item_2, quantity: 2, unit_price: 12345)
      create(:invoice_item, invoice: invoice_1, item: item_3, quantity: 5, unit_price: 12345)

      invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_1, created_at: "2012-04-24")
      create(:invoice_item, invoice: invoice_2, item: item_1, quantity: 4, unit_price: 12345)
      create(:invoice_item, invoice: invoice_2, item: item_2, quantity: 4, unit_price: 12345)
      create(:invoice_item, invoice: invoice_2, item: item_3, quantity: 4, unit_price: 12345)

      invoice_3 = create(:invoice, merchant: merchant_1, customer: customer_1, created_at: "2012-04-25")
      create(:invoice_item, invoice: invoice_3, item: item_1, quantity: 3, unit_price: 12345)
      create(:invoice_item, invoice: invoice_3, item: item_2, quantity: 3, unit_price: 12345)
      create(:invoice_item, invoice: invoice_3, item: item_3, quantity: 3, unit_price: 12345)

      expect(Item.items_by_most_sold(1)).to eq([item_3])
      expect(Item.items_by_most_sold(2)).to eq([item_3, item_2])
      expect(Item.items_by_most_sold(3)).to eq([item_3, item_2, item_1])
    end

    it "returns variable number of top items sold by revenue" do
      customer_1 = create(:customer)
      merchant_1 = create(:merchant)

      item_1 = create(:item, merchant: merchant_1)
      item_2 = create(:item, merchant: merchant_1)
      item_3 = create(:item, merchant: merchant_1)

      invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1, created_at: "2012-04-23")
      create(:invoice_item, invoice: invoice_1, item: item_1, quantity: 2, unit_price: 12345)
      create(:invoice_item, invoice: invoice_1, item: item_2, quantity: 2, unit_price: 32345)
      create(:invoice_item, invoice: invoice_1, item: item_3, quantity: 2, unit_price: 62345)

      invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_1, created_at: "2012-04-24")
      create(:invoice_item, invoice: invoice_2, item: item_1, quantity: 4, unit_price: 12345)
      create(:invoice_item, invoice: invoice_2, item: item_2, quantity: 4, unit_price: 32345)
      create(:invoice_item, invoice: invoice_2, item: item_3, quantity: 4, unit_price: 62345)

      invoice_3 = create(:invoice, merchant: merchant_1, customer: customer_1, created_at: "2012-04-25")
      create(:invoice_item, invoice: invoice_3, item: item_1, quantity: 3, unit_price: 12345)
      create(:invoice_item, invoice: invoice_3, item: item_2, quantity: 3, unit_price: 32345)
      create(:invoice_item, invoice: invoice_3, item: item_3, quantity: 3, unit_price: 62345)

      expect(Item.items_by_most_revenue(1)).to eq([item_3])
      expect(Item.items_by_most_revenue(2)).to eq([item_3, item_2])
      expect(Item.items_by_most_revenue(3)).to eq([item_3, item_2, item_1])
    end
  end
end
