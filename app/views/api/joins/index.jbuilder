json.status "OK"
json.set! :result do
  json.id @group.id
  json.created @group.created_at
  json.updated @group.updated_at
  json.array! @group.users do |user|
    json.id    user.id
    json.name  user.name
    json.email user.email
  end
end