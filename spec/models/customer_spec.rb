require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe "relationships" do
    it {should have_many :invoices}
    it {should have_many :transactions}
  end

  describe "class methods" do
    it "retrieves a customer's most popular merchant by successful transactions" do
      merchant_1 = create(:merchant)
      merchant_2 = create(:merchant)
      merchant_3 = create(:merchant)
      customer_1 = create(:customer)
      customer_2 = create(:customer)

      invoice_1 = create(:invoice, customer: customer_1, merchant: merchant_1)
      invoice_2 = create(:invoice, customer: customer_1, merchant: merchant_1)
      invoice_3 = create(:invoice, customer: customer_1, merchant: merchant_2)
      invoice_4 = create(:invoice, customer: customer_1, merchant: merchant_3)
      invoice_5 = create(:invoice, customer: customer_1, merchant: merchant_3)
      invoice_6 = create(:invoice, customer: customer_1, merchant: merchant_3)
      invoice_7 = create(:invoice, customer: customer_2, merchant: merchant_2)

      create(:transaction, invoice: invoice_1, result: "success")
      create(:transaction, invoice: invoice_2, result: "success")
      create(:transaction, invoice: invoice_3, result: "success")
      create(:transaction, invoice: invoice_4, result: "failed")
      create(:transaction, invoice: invoice_5, result: "failed")
      create(:transaction, invoice: invoice_6, result: "failed")
      create(:transaction, invoice: invoice_7, result: "success")

      expect(customer_1.favorite_merchant).to eq(merchant_1)
    end
  end
end
