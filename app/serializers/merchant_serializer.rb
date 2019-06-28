class MerchantSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name, :created_at, :updated_at

  has_many :invoices
  has_many :items
end
