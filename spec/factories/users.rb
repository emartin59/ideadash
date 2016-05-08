FactoryGirl.define do
  factory :user do
    name Faker::Name.name
    sequence :email do |i|
      "test#{i}@example.com"
    end
    provider 'facebook'
    uid Faker::Code.ean
    password Faker::Internet.password
  end
end
