class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  def find_best_day
    invoices.select("DATE_TRUNC('day', invoices.created_at) AS best_day")
    .select("SUM(invoice_items.quantity) AS total_invoices")
    .group("DATE_TRUNC('day', invoices.created_at)")
    .order("total_invoices DESC")[0]
  end

  def self.items_by_most_sold(limit_quantity)
    select("items.*, SUM(invoice_items.quantity) AS item_quantity")
    .joins(:invoice_items)
    .group(:id)
    .order('item_quantity DESC')
    .limit(limit_quantity)
  end

  def self.items_by_most_revenue(limit_quantity)
    select("items.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue")
    .joins(:invoice_items)
    .group(:id)
    .order('revenue DESC')
    .limit(limit_quantity)
  end
end
