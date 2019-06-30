require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe "relationships" do
    it {should have_many :invoices}
    it {should have_many :items}
  end

  describe "methods" do
    it "retrieves merchants by most revenue" do
      customer_1 = create(:customer)
      merchant_1 = create(:merchant)
      merchant_2 = create(:merchant)
      merchant_3 = create(:merchant)

      item_1 = create(:item, merchant: merchant_1)
      item_2 = create(:item, merchant: merchant_2)
      item_3 = create(:item, merchant: merchant_3)

      invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
      create(:invoice_item, invoice: invoice_1, item: item_1, unit_price: 305, quantity: 3)
      create(:invoice_item, invoice: invoice_1, item: item_1, unit_price: 305, quantity: 3)
      create(:invoice_item, invoice: invoice_1, item: item_1, unit_price: 305, quantity: 3)

      invoice_2 = create(:invoice, merchant: merchant_2, customer: customer_1)
      create(:invoice_item, invoice: invoice_2, item: item_2, unit_price: 105, quantity: 4)
      create(:invoice_item, invoice: invoice_2, item: item_2, unit_price: 105, quantity: 4)
      create(:invoice_item, invoice: invoice_2, item: item_2, unit_price: 105, quantity: 4)

      invoice_3 = create(:invoice, merchant: merchant_3, customer: customer_1)
      create(:invoice_item, invoice: invoice_3, item: item_3, unit_price: 505, quantity: 3)
      create(:invoice_item, invoice: invoice_3, item: item_3, unit_price: 505, quantity: 3)
      create(:invoice_item, invoice: invoice_3, item: item_3, unit_price: 505, quantity: 3)

      create(:transaction, invoice: invoice_1, result: "success")
      create(:transaction, invoice: invoice_2, result: "success")
      create(:transaction, invoice: invoice_3, result: "failed")

      expect(Merchant.most_revenue(2)).to eq([merchant_1, merchant_2])
      expect(Merchant.most_revenue(3)).to eq([merchant_1, merchant_2])
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
      create(:invoice_item, invoice: invoice_1, item: item_1, unit_price: 305, quantity: 3)
      create(:invoice_item, invoice: invoice_1, item: item_1, unit_price: 305, quantity: 3)
      create(:invoice_item, invoice: invoice_1, item: item_1, unit_price: 305, quantity: 3)

      invoice_2 = create(:invoice, merchant: merchant_2, customer: customer_1)
      create(:invoice_item, invoice: invoice_2, item: item_2, unit_price: 105, quantity: 4)
      create(:invoice_item, invoice: invoice_2, item: item_2, unit_price: 105, quantity: 4)
      create(:invoice_item, invoice: invoice_2, item: item_2, unit_price: 105, quantity: 4)

      invoice_3 = create(:invoice, merchant: merchant_3, customer: customer_1)
      create(:invoice_item, invoice: invoice_3, item: item_3, unit_price: 505, quantity: 3)
      create(:invoice_item, invoice: invoice_3, item: item_3, unit_price: 505, quantity: 3)
      create(:invoice_item, invoice: invoice_3, item: item_3, unit_price: 505, quantity: 3)

      create(:transaction, invoice: invoice_1, result: "success")
      create(:transaction, invoice: invoice_2, result: "success")
      create(:transaction, invoice: invoice_3, result: "failed")

      expect(Merchant.most_items(2)[0]).to eq(merchant_2)
      expect(Merchant.most_items(2)[1]).to eq(merchant_1)

      expect(Merchant.most_items(3)[0]).to eq(merchant_2)
      expect(Merchant.most_items(3)[1]).to eq(merchant_1)
      expect(Merchant.most_items(3)[2]).to eq(nil)
    end

    it "retrieves a merchant's most popular customer by successful transactions" do
      customer_1 = create(:customer)
      customer_2 = create(:customer)
      customer_3 = create(:customer)
      merchant_1 = create(:merchant)
      merchant_2 = create(:merchant)

      invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
      invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_1)
      invoice_3 = create(:invoice, merchant: merchant_1, customer: customer_2)
      invoice_4 = create(:invoice, merchant: merchant_1, customer: customer_3)
      invoice_5 = create(:invoice, merchant: merchant_1, customer: customer_3)
      invoice_6 = create(:invoice, merchant: merchant_1, customer: customer_3)
      invoice_7 = create(:invoice, merchant: merchant_2, customer: customer_2)

      create(:transaction, invoice: invoice_1, result: "success")
      create(:transaction, invoice: invoice_2, result: "success")
      create(:transaction, invoice: invoice_3, result: "success")
      create(:transaction, invoice: invoice_4, result: "failed")
      create(:transaction, invoice: invoice_5, result: "failed")
      create(:transaction, invoice: invoice_6, result: "failed")
      create(:transaction, invoice: invoice_7, result: "success")

      expect(merchant_1.favorite_customer).to eq(customer_1)
    end

    it "gets transaction revenue for a certain merchant for one date" do
      customer_1 = create(:customer)
      merchant_1 = create(:merchant)
      merchant_2 = create(:merchant)

      invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1, updated_at: "2012-03-27T14:54:05.000Z")
      invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_1, updated_at: "2012-03-27T14:54:05.000Z")
      invoice_3 = create(:invoice, merchant: merchant_1, customer: customer_1, updated_at: "2013-03-27T14:54:05.000Z")
      invoice_4 = create(:invoice, merchant: merchant_2, customer: customer_1, updated_at: "2012-03-27T14:54:05.000Z")
      invoice_5 = create(:invoice, merchant: merchant_1, customer: customer_1, updated_at: "2012-03-27T14:54:05.000Z")

      create(:transaction, invoice: invoice_1, result: "success")
      create(:transaction, invoice: invoice_2, result: "success")
      create(:transaction, invoice: invoice_3, result: "success")
      create(:transaction, invoice: invoice_4, result: "success")
      create(:transaction, invoice: invoice_5, result: "failed")

      item_1 = create(:item, merchant: merchant_1)

      invoice_item_1 = create(:invoice_item, invoice: invoice_1, item: item_1, quantity: 5, unit_price: 100)
      invoice_item_2 = create(:invoice_item, invoice: invoice_2, item: item_1, quantity: 5, unit_price: 100)
      invoice_item_3 = create(:invoice_item, invoice: invoice_3, item: item_1, quantity: 5, unit_price: 100)
      invoice_item_4 = create(:invoice_item, invoice: invoice_4, item: item_1, quantity: 5, unit_price: 100)
      invoice_item_5 = create(:invoice_item, invoice: invoice_5, item: item_1, quantity: 5, unit_price: 100)

      revenue_1 = (invoice_item_1.quantity * invoice_item_1.unit_price).to_r
      revenue_2 = (invoice_item_2.quantity * invoice_item_2.unit_price).to_r
      valid_revenue = revenue_1 + revenue_2
      date = "2012-03-27"
      expect(merchant_1.day_transactions_revenue(date).revenue).to eq(valid_revenue)
    end

    it "gets transaction revenue for a certain merchant for all dates" do
      customer_1 = create(:customer)
      merchant_1 = create(:merchant)
      merchant_2 = create(:merchant)

      invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1, updated_at: "2012-03-27T14:54:05.000Z")
      invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_1, updated_at: "2012-03-27T14:54:05.000Z")
      invoice_3 = create(:invoice, merchant: merchant_1, customer: customer_1, updated_at: "2013-03-27T14:54:05.000Z")
      invoice_4 = create(:invoice, merchant: merchant_2, customer: customer_1, updated_at: "2012-03-27T14:54:05.000Z")
      invoice_5 = create(:invoice, merchant: merchant_1, customer: customer_1, updated_at: "2012-03-27T14:54:05.000Z")

      create(:transaction, invoice: invoice_1, result: "success")
      create(:transaction, invoice: invoice_2, result: "success")
      create(:transaction, invoice: invoice_3, result: "success")
      create(:transaction, invoice: invoice_4, result: "success")
      create(:transaction, invoice: invoice_5, result: "failed")

      item_1 = create(:item, merchant: merchant_1)

      invoice_item_1 = create(:invoice_item, invoice: invoice_1, item: item_1, quantity: 5, unit_price: 100)
      invoice_item_2 = create(:invoice_item, invoice: invoice_2, item: item_1, quantity: 5, unit_price: 100)
      invoice_item_3 = create(:invoice_item, invoice: invoice_3, item: item_1, quantity: 5, unit_price: 100)
      invoice_item_4 = create(:invoice_item, invoice: invoice_4, item: item_1, quantity: 5, unit_price: 100)
      invoice_item_5 = create(:invoice_item, invoice: invoice_5, item: item_1, quantity: 5, unit_price: 100)

      revenue_1 = (invoice_item_1.quantity * invoice_item_1.unit_price).to_r
      revenue_2 = (invoice_item_2.quantity * invoice_item_2.unit_price).to_r
      revenue_3 = (invoice_item_3.quantity * invoice_item_3.unit_price).to_r
      valid_revenue = revenue_1 + revenue_2 + revenue_3
      expect(merchant_1.day_transactions_revenue.revenue).to eq(valid_revenue)
    end

    it "retrieves a merchant's customers with pending orders" do ### Boss Mode
#       customer_1 = create(:customer)
#       customer_2 = create(:customer)
#       customer_3 = create(:customer)
#       merchant_1 = create(:merchant)
#       merchant_2 = create(:merchant)
#
#       invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1)
#       invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_1)
#       invoice_3 = create(:invoice, merchant: merchant_1, customer: customer_2)
#       invoice_4 = create(:invoice, merchant: merchant_1, customer: customer_3)
#       invoice_5 = create(:invoice, merchant: merchant_1, customer: customer_3)
#       invoice_6 = create(:invoice, merchant: merchant_1, customer: customer_3)
#       invoice_7 = create(:invoice, merchant: merchant_2, customer: customer_2)
#
#       create(:transaction, invoice: invoice_1, result: "failed")
#       create(:transaction, invoice: invoice_2, result: "success")
#       create(:transaction, invoice: invoice_3, result: "success")
#       create(:transaction, invoice: invoice_4, result: "failed")
#       create(:transaction, invoice: invoice_5, result: "failed")
#       create(:transaction, invoice: invoice_6, result: "failed")
#       create(:transaction, invoice: invoice_7, result: "failed")
#       assert_equal [customer_1, customer_2], merchant_1.customers_with_pending_invoices
    end
  end
end
