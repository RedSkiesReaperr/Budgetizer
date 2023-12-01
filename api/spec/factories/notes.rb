# frozen_string_literal: true

FactoryBot.define do
  factory :note do
    title { Faker::Company.name }
    description { Faker::GreekPhilosophers.quote }
    month { Faker::Number.within(range: 1...12) }
    year { Faker::Number.within(range: 2020...2025) }
    user
  end
end
