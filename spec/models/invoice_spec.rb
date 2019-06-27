require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "relationships" do
    it {should belong_to :customer}
    it {should belong_to :merchant}
    it {should have_many :invoice_items}
    it {should have_many :items}
    it {should have_many :transactions}
  end

  describe "class methods" do
    it "retrieves all revenue for successful transactions on a certain date" do
      customer_1 = create(:customer)
      merchant_1 = create(:merchant)

      item_1 = create(:item, merchant: merchant_1)

      invoice_1 = create(:invoice, merchant: merchant_1, customer: customer_1, updated_at: "2012-03-27 14:54:10 UTC")
      invoice_item_1 = create(:invoice_item, invoice: invoice_1, item: item_1, unit_price: 305, quantity: 3)
      invoice_item_2 = create(:invoice_item, invoice: invoice_1, item: item_1, unit_price: 305, quantity: 3)
      invoice_item_3 = create(:invoice_item, invoice: invoice_1, item: item_1, unit_price: 305, quantity: 3)

      invoice_2 = create(:invoice, merchant: merchant_1, customer: customer_1, updated_at: "2012-03-26 14:54:10 UTC")
      invoice_item_4 = create(:invoice_item, invoice: invoice_2, item: item_1, unit_price: 305, quantity: 3)
      invoice_item_5 = create(:invoice_item, invoice: invoice_2, item: item_1, unit_price: 305, quantity: 3)
      invoice_item_6 = create(:invoice_item, invoice: invoice_2, item: item_1, unit_price: 305, quantity: 3)

      invoice_3 = create(:invoice, merchant: merchant_1, customer: customer_1, updated_at: "2012-03-27 14:54:10 UTC")
      invoice_item_7 = create(:invoice_item, invoice: invoice_2, item: item_1, unit_price: 305, quantity: 3)
      invoice_item_8 = create(:invoice_item, invoice: invoice_2, item: item_1, unit_price: 305, quantity: 3)
      invoice_item_9 = create(:invoice_item, invoice: invoice_2, item: item_1, unit_price: 305, quantity: 3)

      transaction_1 = create(:transaction, invoice: invoice_1, result: "success")
      transaction_2 = create(:transaction, invoice: invoice_2, result: "success")
      transaction_3 = create(:transaction, invoice: invoice_3, result: "failed")

      revenue_1 = (invoice_item_1.quantity * invoice_item_1.unit_price)
      revenue_2 = (invoice_item_2.quantity * invoice_item_2.unit_price)
      revenue_3 = (invoice_item_3.quantity * invoice_item_3.unit_price)
      expected_revenue = revenue_1 + revenue_2 + revenue_3

      date = "2012-03-27"

      actual_revenue = Invoice.revenue(date).total_revenue
      assert_equal expected_revenue, actual_revenue
    end
  end
end
