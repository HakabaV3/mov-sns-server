FactoryGirl.define do
  factory :group do
    sequence(:name) { |n| "Hakaba#{n}" }
    description "The Hakaba."

    owner_id { create(:user).id }
    users {
      create_list(:user, 3)
    }
  end
  
end
