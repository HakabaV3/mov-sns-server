json.status "OK"
json.set! :result do
  json.array! @groups do |group|
    json.id          group.id
    json.name        group.name
    json.description group.description
    json.array! group.users do |user|
      json.id    user.id
      json.name  user.name
      json.email user.email
    end
  end
end