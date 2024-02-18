# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

NUMBER_OF_LINES_PER_USER = Faker::Number.within(range: 30..60)
NUMBER_OF_OPERATIONS = Faker::Number.within(range: 1000..10_000)
NUMBER_OF_NOTES = Faker::Number.within(range: 0..50)
NUMBER_OF_CATEGORIES = Faker::Number.within(range: 10..30)

user = User.create!(provider: 'email',
                    uid: 'john.doe@gmail.com',
                    password: '123azerty',
                    name: 'John',
                    nickname: 'John.Doe',
                    email: 'john.doe@gmail.com')

variation = Faker::Number.within(range: 0..20)
vital = 50 - (variation / Faker::Number.within(range: 1..10))
non_essential = 30 + (variation / Faker::Number.within(range: 1..5))
saving = 100 - vital - non_essential
Objective.create!(vital:, non_essential:, saving:, user:)

NUMBER_OF_CATEGORIES.times do
  key = "category_#{Faker::Alphanumeric.alpha(number: 10)}"
  color = Faker::Color.hex_color
  icon = "mdi-#{Faker::Alphanumeric.alpha(number: 10)}"

  Category.create!(key:, color:, icon:, user:)
end

NUMBER_OF_LINES_PER_USER.times do
  amount = Faker::Number.within(range: -500.0..500.0)
  category = Faker::Number.within(range: 0...Line.categories.size)
  line_type = if amount.positive?
                :income
              else
                Faker::Boolean.boolean ? :vital : :non_essential
              end
  Line.create!(label: Faker::Hobby.activity, amount:, line_type:, category:, user:)
end

NUMBER_OF_OPERATIONS.times do
  date = Faker::Date.between(from: 6.months.ago, to: 1.day.ago)
  label = "#{Faker::Invoice.reference} #{Faker::Company.name}"
  amount = Faker::Number.within(range: -500.0..500.0)
  comment = Faker::Boolean.boolean ? Faker::ChuckNorris.fact : nil
  pointed = Faker::Boolean.boolean
  op_type = if amount.positive?
              :income
            else
              Faker::Number.within(range: 1...Operation.op_types.size)
            end

  Operation.create!(
    category: Faker::Number.within(range: 0...Operation.categories.size),
    date:,
    label:,
    amount:,
    comment:,
    pointed:,
    op_type:
  )
end

NUMBER_OF_NOTES.times do
  title = Faker::Dessert.variety
  description = Faker::ChuckNorris.fact
  month = Faker::Number.within(range: 1...12)
  year = Faker::Number.within(range: 2020...2025)

  Note.create!(title:, description:, month:, year:, user:)
end
