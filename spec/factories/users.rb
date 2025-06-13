FactoryBot.define do
  password = Faker::Internet.unique.password(min_length: 6, max_length: 8)

  factory :user do
    email { Faker::Internet.email(domain: 'example') }
    name { Faker::Internet.username(specifier: 5..8) }
    sequence(:account) { |n| "sample#{n}" }
    password { password }
    password_confirmation { password }
    body { 'a' * 20 }
    x_account { 'https://x.com/sample' }
    instagram_account { 'https://www.instagram.com/sample/' }
    youtube_account { 'https://www.youtube.com/sample/' }
  end
end
