FactoryGirl.define do
  factory :subscriber do
    sequence :email do |i|
      "test#{i}@example.com"
    end
  end
end
