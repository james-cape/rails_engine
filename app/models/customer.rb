class Customer < ApplicationRecord
  has_many :invoices
  has_many :transactions, through: :invoices

  def favorite_merchant
    Merchant.select('merchants.*, COUNT(transactions.id) AS total_transactions')
    .joins(invoices: :transactions)
    .where(transactions: {result: "success"})
    .where("invoices.customer_id = ?", self.id)
    .group(:id)
    .order('total_transactions DESC')
    .first
  end
end
