class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :transactions

  def self.revenue(date)

    day_start = date.to_datetime.beginning_of_day.utc
    day_end = date.to_datetime.end_of_day.utc

    # day_start = "2012-03-25".to_datetime.beginning_of_day.utc
    # day_end = "2012-03-25".to_datetime.end_of_day.utc
# require 'pry'; binding.pry
    # select("SUM(invoice_items.quantity * invoice_items.unit_price)").joins(invoices: [:invoice_items, :transactions]).where(invoices: {created_at: [day_start..day_end]}).where(transactions: {result: "success"})
    joins(invoices: [:invoice_items, :transactions]).where(invoice: {created_at: [day_start..day_end]}).where(transactions: {result: "success"}).sum('invoice_items.quantity * invoice_items.unit_price')

  end
end
