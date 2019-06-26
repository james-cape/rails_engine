class Merchant < ApplicationRecord
  has_many :invoices
  has_many :items

  def self.most_revenue(merchant_limit)
    select('merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue)')
    .joins(:invoices)
    .joins(:transactions)
    .joins(:invoice_items)
    .where('transactions.result = ?', "success")
    .group(:id)
    .order('revenue DESC')
    .limit(merchant_limit)



  end
end
