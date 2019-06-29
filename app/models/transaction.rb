class Transaction < ApplicationRecord
  belongs_to :invoice

  # scope :successful, -> { joins(:invoices).where(result: "failed")}

  scope :successful, -> { where(result: "success") }
end
