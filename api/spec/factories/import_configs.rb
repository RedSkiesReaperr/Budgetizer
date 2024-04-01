# frozen_string_literal: true

FactoryBot.define do
  factory :import_config do
    value { Faker::Company.name }
    category { association :category, user: }
    user
  end
end
