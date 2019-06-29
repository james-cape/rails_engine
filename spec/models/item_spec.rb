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

      assert_equal "2012-04-24".to_datetime, item_1.find_best_day.best_day
      assert_equal "2012-04-24".to_datetime, item_2.find_best_day.best_day
      assert_equal "2012-04-23".to_datetime, item_3.find_best_day.best_day
    end
  end
end
