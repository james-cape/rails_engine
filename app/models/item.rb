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
end
