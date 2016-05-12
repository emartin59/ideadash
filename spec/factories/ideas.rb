FactoryGirl.define do
  factory :idea do
    sequence :title do |i|
      "Idea #{i}"
    end
    summary Faker::Company.catch_phrase
    description Faker::Lorem.paragraph
    user
  end
end
