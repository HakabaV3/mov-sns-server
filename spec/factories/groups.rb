FactoryGirl.define do
  factory :group do
    name "Hakaba"
    description "The Hakaba."
    owner_id 100
    
    association :owner, factory: :user, id: 100,
                                        name: "kikurage",
                                        email: "kikurage@sample.com",
                                        password: "kikurage_password",
                                        strategy: :create
    users {
      create_list(:user, 10)
    }
  end
  
end
