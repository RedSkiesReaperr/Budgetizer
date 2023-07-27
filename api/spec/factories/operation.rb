FactoryBot.define do
  factory :operation do
    date { Faker::Date.backward(days: 14) }
    label { Faker::Company.name }
    amount { Faker::Number.decimal(l_digits: 2) }
    comment { Faker::Quote.yoda }
    pointed { false }
    op_type { :unknown }
    identifier { Faker::Alphanumeric.alpha(number: 30) }
    category { :to_categorize }
  end
end
