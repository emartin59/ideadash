FactoryGirl.define do
  factory :payment do
    association :sender, factory: :user
    association :recipient, factory: :idea
    amount 1.5
  end
end
