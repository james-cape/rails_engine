require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe "relationships" do
    it {should have_many :invoices}
    it {should have_many :items}
  end

  describe "class methods" do
    it "retrieves merchants by most revenue" do
      customer_1 = create(:customer)
      merchant_1 = create(:merchant)
      merchant_2 = create(:merchant)
      merchant_3 = create(:merchant)

      item_1 = create(:item, merchant: merchant_1)
      item_2 = create(:item, merchant: merchant_2)
      item_3 = create(:item, merchant: merchant_3)

      invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
      invoice_item_1 = create(:invoice_item, invoice: invoice_1, item: item_1, unit_price: 305, quantity: 3)
      invoice_item_2 = create(:invoice_item, invoice: invoice_1, item: item_1, unit_price: 305, quantity: 3)
      invoice_item_3 = create(:invoice_item, invoice: invoice_1, item: item_1, unit_price: 305, quantity: 3)

      invoice_2 = create(:invoice, merchant: merchant_2, customer: customer_1)
      invoice_item_4 = create(:invoice_item, invoice: invoice_2, item: item_2, unit_price: 105, quantity: 4)
      invoice_item_5 = create(:invoice_item, invoice: invoice_2, item: item_2, unit_price: 105, quantity: 4)
      invoice_item_6 = create(:invoice_item, invoice: invoice_2, item: item_2, unit_price: 105, quantity: 4)

      invoice_3 = create(:invoice, merchant: merchant_3, customer: customer_1)
      invoice_item_7 = create(:invoice_item, invoice: invoice_3, item: item_3, unit_price: 505, quantity: 3)
      invoice_item_8 = create(:invoice_item, invoice: invoice_3, item: item_3, unit_price: 505, quantity: 3)
      invoice_item_9 = create(:invoice_item, invoice: invoice_3, item: item_3, unit_price: 505, quantity: 3)

      transaction_1 = create(:transaction, invoice: invoice_1, result: "success")
      transaction_2 = create(:transaction, invoice: invoice_2, result: "success")
      transaction_3 = create(:transaction, invoice: invoice_3, result: "failed")

      assert_equal [merchant_1, merchant_2], Merchant.most_revenue(2)
      assert_equal [merchant_1, merchant_2], Merchant.most_revenue(3)
    end

    it "retrieves merchants by most items" do
      customer_1 = create(:customer)
      merchant_1 = create(:merchant)
      merchant_2 = create(:merchant)
      merchant_3 = create(:merchant)

      item_1 = create(:item, merchant: merchant_1)
      item_2 = create(:item, merchant: merchant_1)
      item_3 = create(:item, merchant: merchant_1)
      item_4 = create(:item, merchant: merchant_2)
      item_5 = create(:item, merchant: merchant_2)
      item_6 = create(:item, merchant: merchant_3)

      invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
      invoice_item_1 = create(:invoice_item, invoice: invoice_1, item: item_1, unit_price: 305, quantity: 3)
      invoice_item_2 = create(:invoice_item, invoice: invoice_1, item: item_1, unit_price: 305, quantity: 3)
      invoice_item_3 = create(:invoice_item, invoice: invoice_1, item: item_1, unit_price: 305, quantity: 3)

      invoice_2 = create(:invoice, merchant: merchant_2, customer: customer_1)
      invoice_item_4 = create(:invoice_item, invoice: invoice_2, item: item_2, unit_price: 105, quantity: 4)
      invoice_item_5 = create(:invoice_item, invoice: invoice_2, item: item_2, unit_price: 105, quantity: 4)
      invoice_item_6 = create(:invoice_item, invoice: invoice_2, item: item_2, unit_price: 105, quantity: 4)

      invoice_3 = create(:invoice, merchant: merchant_3, customer: customer_1)
      invoice_item_7 = create(:invoice_item, invoice: invoice_3, item: item_3, unit_price: 505, quantity: 3)
      invoice_item_8 = create(:invoice_item, invoice: invoice_3, item: item_3, unit_price: 505, quantity: 3)
      invoice_item_9 = create(:invoice_item, invoice: invoice_3, item: item_3, unit_price: 505, quantity: 3)

      transaction_1 = create(:transaction, invoice: invoice_1, result: "success")
      transaction_2 = create(:transaction, invoice: invoice_2, result: "success")
      transaction_3 = create(:transaction, invoice: invoice_3, result: "failed")

      assert_equal [merchant_1, merchant_2], Merchant.most_items(2)
      assert_equal [merchant_1, merchant_2], Merchant.most_items(3)
      assert_equal [merchant_1, merchant_2], Merchant.most_items(4)
    end
  end
end
