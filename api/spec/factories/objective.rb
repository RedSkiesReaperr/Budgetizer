# frozen_string_literal: true

FactoryBot.define do
  factory :objective do
    vital { 50 }
    non_essential { 30 }
    saving { 20 }
  end
end
