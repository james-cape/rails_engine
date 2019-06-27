class Merchant < ApplicationRecord
  has_many :invoices
  has_many :items

  def self.most_revenue(merchant_limit)
    select('merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue')
    .joins(invoices: [:invoice_items, :transactions])
    .where(transactions: {result: "success"})
    .group(:id)
    .order('revenue DESC')
    .limit(merchant_limit)
  end

  def self.most_items(merchant_limit)
    select('merchants.*, SUM(invoice_items.quantity) AS total_items')
    .joins(invoices: [:invoice_items, :transactions])
    .where(transactions: {result: "success"})
    .group(:id)
    .order('total_items DESC')
    .order(:id)
    .limit(merchant_limit).to_a.reverse
  end
end
