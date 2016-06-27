FactoryGirl.define do
  factory :comment do
    body Faker::Company.catch_phrase
    user
    association :commentable, factory: :idea
  end
end
