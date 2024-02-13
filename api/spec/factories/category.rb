# frozen_string_literal: true

FactoryBot.define do
  factory :category do
    user
    key { "category_#{Faker::Alphanumeric.alpha(number: 10)}" }
    color { Faker::Color.hex_color }
    icon { 'mdi-icon' }
  end
end
