FactoryGirl.define do
  factory :user do
    sequence(:id) { |n| 100+n }
    sequence(:name) { |n| "kikurage#{n}" }
    sequence(:email) { |n| "kikurage#{n}@sample.com" }
    password "kikurage_password"
  end

end
