FactoryGirl.define do
  factory :session do
    user
    sequence(:token) { |n| "abcdefg#{n}" }
  end
  
end
