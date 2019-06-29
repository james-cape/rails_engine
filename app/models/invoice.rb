class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :transactions

  def self.revenue(date)
    select('SUM(invoice_items.quantity * invoice_items.unit_price) AS total_revenue')
    .joins(:invoice_items, :transactions)
    .merge(Transaction.successful)
    .where("DATE_TRUNC('day', invoices.updated_at) = ?", date)[0]
  end
end
