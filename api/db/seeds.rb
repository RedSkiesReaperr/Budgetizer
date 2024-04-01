# frozen_string_literal: true

# rubocop:disable Rails/Output

puts '===== Seeding database ====='

NUMBER_OF_LINES_PER_USER = Faker::Number.within(range: 30..60)
NUMBER_OF_OPERATIONS = Faker::Number.within(range: 1000..10_000)
NUMBER_OF_NOTES = Faker::Number.within(range: 0..50)
NUMBER_OF_CATEGORIES = Faker::Number.within(range: 10..30)
NUMBER_OF_IMPORT_CONFIGS = Faker::Number.within(range: 3..10)

user = User.create!(provider: 'email',
                    uid: 'john.doe@gmail.com',
                    password: '123azerty',
                    name: 'John',
                    nickname: 'John.Doe',
                    email: 'john.doe@gmail.com')

User.create!(provider: 'email',
             uid: 'foo.bar@gmail.com',
             password: '123foobar',
             name: 'Foo',
             nickname: 'Foo.Bar',
             email: 'foo.bar@gmail.com')
puts '✓ Users created'

variation = Faker::Number.within(range: 0..20)
vital = 50 - (variation / Faker::Number.within(range: 1..10))
non_essential = 30 + (variation / Faker::Number.within(range: 1..5))
saving = 100 - vital - non_essential
Objective.create!(vital:, non_essential:, saving:, user:)
puts '✓ Objective created'

NUMBER_OF_CATEGORIES.times do
  key = "category_#{Faker::Alphanumeric.alpha(number: 10)}"
  color = Faker::Color.hex_color
  icon = "mdi-#{Faker::Alphanumeric.alpha(number: 10)}"

  Category.create!(key:, color:, icon:, user:)
end
puts "✓ #{NUMBER_OF_CATEGORIES} Categories created"

NUMBER_OF_LINES_PER_USER.times do
  amount = Faker::Number.within(range: -500.0..500.0)
  user_categories = user.categories
  category_index = Faker::Number.within(range: 0...user_categories.size)
  category = Faker::Boolean.boolean ? user_categories[category_index] : nil # Some lines need to have an empty category
  line_type = if amount.positive?
                :income
              else
                Faker::Boolean.boolean ? :vital : :non_essential
              end
  Line.create!(label: Faker::Hobby.activity, amount:, line_type:, category:, user:)
end
puts "✓ #{NUMBER_OF_LINES_PER_USER} Lines created"

NUMBER_OF_OPERATIONS.times do
  date = Faker::Date.between(from: 6.months.ago, to: 1.day.ago)
  label = "#{Faker::Invoice.reference} #{Faker::Company.name}"
  amount = Faker::Number.within(range: -500.0..500.0)
  user_categories = user.categories
  category_index = Faker::Number.within(range: 0...user_categories.size)
  category = Faker::Boolean.boolean ? user_categories[category_index] : nil # Some operations needs an empty category
  comment = Faker::Boolean.boolean ? Faker::ChuckNorris.fact : nil
  pointed = Faker::Boolean.boolean
  op_type = if amount.positive?
              :income
            else
              Faker::Number.within(range: 1...Operation.op_types.size)
            end

  Operation.create!(
    category:,
    date:,
    label:,
    amount:,
    comment:,
    pointed:,
    op_type:,
    user:
  )
end
puts "✓ #{NUMBER_OF_OPERATIONS} Operations created"

NUMBER_OF_NOTES.times do
  title = Faker::Dessert.variety
  description = Faker::ChuckNorris.fact
  month = Faker::Number.within(range: 1...12)
  year = Faker::Number.within(range: 2020...2025)

  Note.create!(title:, description:, month:, year:, user:)
end
puts "✓ #{NUMBER_OF_NOTES} Notes created"

NUMBER_OF_IMPORT_CONFIGS.times do
  category_id = Faker::Number.within(range: 1...NUMBER_OF_CATEGORIES)

  ImportConfig.create!(value: Faker::Company.name, user:, category_id:)
end
puts "✓ #{NUMBER_OF_IMPORT_CONFIGS} ImportConfigs created"

# rubocop:enable Rails/Output
