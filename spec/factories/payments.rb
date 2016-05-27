FactoryGirl.define do
  factory :payment do
    sender nil
    recipient nil
    amount 1.5
    paypal_id "MyString"
  end
end
