FactoryBot.define do
  factory :invoice do
    customer { nil }
    merchant { nil }
    status { "MyString" }
    created_at { "2019-06-24 18:34:33" }
    updated_at { "2019-06-24 18:34:33" }
  end
end
