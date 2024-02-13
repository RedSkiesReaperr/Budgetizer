# frozen_string_literal: true

FactoryBot.define do
  factory :category do
    user
    key { 'category_key' }
    color { Faker::Color.hex_color }
    icon { '#2980b9' }
  end
end
