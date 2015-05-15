json.status "OK"
json.set! :result do
  json.id          @group.id
  json.created     @group.created_at
  json.updated     @group.updated_at
  json.name        @group.name
  json.description @group.description
end