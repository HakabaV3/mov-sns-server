json.status "OK"
json.set! :result do
  json.set! :users do
    json.array! @group.users do |user|
      json.id      user.id
      json.created user.created_at
      json.updated user.updated_at
      json.name    user.name
      json.email   user.email
    end
  end
end