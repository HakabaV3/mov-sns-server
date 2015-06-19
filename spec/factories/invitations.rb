FactoryGirl.define do
  factory :invitation do
    owner_id { create(:user).id }
  	target_id { create(:user).id }
    group_id { create(:group, users: [User.find_by(id: target_id), User.find_by(id: owner_id)]).id }
  end

end
