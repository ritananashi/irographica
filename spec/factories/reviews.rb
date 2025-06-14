FactoryBot.define do
  factory :review do
    title { Faker::Lorem.characters(number: 10) }
    body { Faker::Lorem.sentence }
    paper { Faker::Lorem.characters(number: 10) }
    pen { Faker::Lorem.characters(number: 10) }
    association :user
    association :product
  end
end
