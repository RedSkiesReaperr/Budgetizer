# frozen_string_literal: true

FactoryBot.define do
  factory :budget do
    objective
    name { Faker::Lorem.word }
  end
end
