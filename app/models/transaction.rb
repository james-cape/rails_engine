class Transaction < ApplicationRecord
  belongs_to :invoice

  # scope :failed, -> { joins(:invoices).where(result: "failed")}
end
