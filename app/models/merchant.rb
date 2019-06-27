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

  def favorite_customer
    # customer who has conducted the most total number of successful transactions.
    # merchants to Invoices
    # invoices to customers
    # invoices to transactions
    select('customers.*, COUNT(transactions.id) AS total_transactions')
    .joins(invoices: [:customers, :transactions])
    .where(transactions: {result: "success"})
    .group('customers.id')
    .order('total_transactions DESC')
    .first
  end
end
