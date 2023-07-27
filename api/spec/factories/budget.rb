FactoryBot.define do
  factory :budget do
    objective { build(:objective) }
    name { Faker::Lorem.word }
  end
end
