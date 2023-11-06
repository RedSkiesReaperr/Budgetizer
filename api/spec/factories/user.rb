# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    provider { 'email' }
    uid { Faker::Alphanumeric.alphanumeric(number: 10) }
    password { Faker::Internet.password }
    name { Faker::Name.first_name }
    nickname { Faker::Internet.user_name }
    email { Faker::Internet.email }
  end
end
