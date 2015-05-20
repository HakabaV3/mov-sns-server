json.status "OK"
json.set! :result do
  json.id          @group.id
  json.created     @group.created_at
  json.updated     @group.updated_at
  json.name        @group.name
  json.description @group.description
  json.set! :users do
    json.array! @users do |user|
      json.id    user.id
      json.name  user.name
      json.email user.email
    end
  end
end