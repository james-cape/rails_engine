FactoryBot.define do
  factory :transaction do
    invoice { nil }
    credit_card_number { "MyString" }
    credit_card_expiration_date { "2019-06-24 18:44:45" }
    result { "MyString" }
    created_at { "2019-06-24 18:44:45" }
    updated_at { "2019-06-24 18:44:45" }
  end
end
