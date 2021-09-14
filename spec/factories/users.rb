FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { "Abcxyz@gmail.com" }
    password { "123456" }
    password_confirmation { "123456" }
  end
end
