# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create!([
  {id: 1, name: "kikura", email: "kikura@sample.com", password: "kikura_password", password_confirmation: "kikura_password"},
  {id: 2, name: "jinssk", email: "jinssk@sample.com", password: "jinssk_password", password_confirmation: "jinssk_password"},
  {id: 3, name: "togsho", email: "togsho@sample.com", password: "togsho_password", password_confirmation: "togsho_password"}
])

Group.create!([
  {id: 1, owner_id: 1, name: "Hakaba", description: "Programming Group"},
  {id: 2, owner_id: 2, name: "Science", description: "Science Course Group"},
  {id: 3, owner_id: 3, name: "Economic", description: "Economic Course Group"}
])

UserGroup.create!([
  {id: 1, user_id: 1, group_id: 1},
  {id: 2, user_id: 2, group_id: 1},
  {id: 3, user_id: 3, group_id: 1},
  {id: 4, user_id: 1, group_id: 2},
  {id: 5, user_id: 2, group_id: 2},
  {id: 6, user_id: 3, group_id: 3}
])

Invitation.create!([
  {id: 1, owner_id: 1, target_id: 3, group_id: 2},
  {id: 2, owner_id: 3, target_id: 2, group_id: 3}
])

Movie.create!([
  {id: 1, user_id: 1, group_id: 1, name: "Kikura Movie", description: "Sample Sample Sample Sample Sample", path: "/hakaba/1431242818.mov"},
  {id: 2, user_id: 2, group_id: 2, name: "Jinssk Movie", description: "Sample Sample Sample Sample Sample", path: "/hakaba/1431242818.mov"},
  {id: 3, user_id: 3, group_id: 3, name: "TogSho Movie", description: "Sample Sample Sample Sample Sample", path: "/hakaba/1431242818.mov"}
])