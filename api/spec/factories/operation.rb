# frozen_string_literal: true

FactoryBot.define do
  factory :operation do
    date { Faker::Date.backward(days: 14) }
    label { Faker::Company.name }
    amount { Faker::Number.decimal(l_digits: 2) }
    comment { Faker::Quote.yoda }
    pointed { false }
    op_type { :unknown }
    category { :to_categorize }
    user
  end
end
