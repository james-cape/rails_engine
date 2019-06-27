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
    .limit(merchant_limit)
  end

#   def self.revenue(date)
#
#     day_start = date.to_datetime.beginning_of_day.utc
#     day_end = date.to_datetime.end_of_day.utc
#
#     # day_start = "2012-03-25".to_datetime.beginning_of_day.utc
#     # day_end = "2012-03-25".to_datetime.end_of_day.utc
# # require 'pry'; binding.pry
#     # select("SUM(invoice_items.quantity * invoice_items.unit_price)").joins(invoices: [:invoice_items, :transactions]).where(invoices: {created_at: [day_start..day_end]}).where(transactions: {result: "success"})
#     joins(invoices: [:invoice_items, :transactions]).where(invoice: {created_at: [day_start..day_end]}).where(transactions: {result: "success"}).sum('invoice_items.quantity * invoice_items.unit_price')
#
#   end
end
