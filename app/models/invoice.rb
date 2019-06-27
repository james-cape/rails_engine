class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :transactions

  def self.revenue(date)
    select('SUM(invoice_items.quantity * invoice_items.unit_price) AS total_revenue')
    .joins(:invoice_items, :transactions)
    .where("DATE_TRUNC('day', invoices.created_at) = ?", date)
    .where(transactions: {result: "success"})[0]
  end
end
