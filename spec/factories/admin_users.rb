FactoryBot.define do
  factory :admin_user do
    email { Faker::Internet.email }
    password { Faker::Alphanumeric.alphanumeric(:number => 10) }
  end
end
