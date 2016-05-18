FactoryGirl.define do
  factory :vote do
    association :positive_idea, factory: :idea
    association :negative_idea, factory: :idea
    user
  end
end
