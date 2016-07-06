FactoryGirl.define do
  factory :backer_vote do
    user
    idea
    kind 'extend'
  end
end
