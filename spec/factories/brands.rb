FactoryBot.define do
  factory :brand do
    name { Faker::Lorem.characters(number: 10) }
    official_url { Faker::Internet.url }
    official_shopping_url { Faker::Internet.url }
  end
end
