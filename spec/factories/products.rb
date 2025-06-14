FactoryBot.define do
  factory :product do
    name { Faker::Lorem.characters(number: 10) }
    category { Category.all.sample }
    association :brand
  end
end
