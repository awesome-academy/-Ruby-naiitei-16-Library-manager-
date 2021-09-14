FactoryBot.define do
  factory :admin, class: User do
    name { Faker::Name.name }
    email { "hello@gmail.com" }
    password { Faker::Internet.password(min_length: 10, max_length: 20) }
    role { "admin" }
  end
end
