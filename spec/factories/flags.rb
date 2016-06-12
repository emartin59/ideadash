FactoryGirl.define do
  factory :flag do
    user
    association :flaggable, factory: :idea
    kind "spam"
  end
end
