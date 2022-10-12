FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { "Bdoz@#{rand(1111..9999)}" }
  end
end
