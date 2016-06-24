FactoryGirl.define do
  factory :implementation do
    title Faker::Company.name
    summary Faker::Company.catch_phrase
    user
    idea
  end
end
