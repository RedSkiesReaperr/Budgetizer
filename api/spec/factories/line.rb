# frozen_string_literal: true

FactoryBot.define do
  factory :line do
    label { Faker::Company.name }
    amount { Faker::Number.decimal(l_digits: 2) }
    line_type { :vital }
    budget
    category { :to_categorize }
  end
end
