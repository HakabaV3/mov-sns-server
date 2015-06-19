json.status "OK"
json.set! :result do
  json.set! :user do
    json.id      @current_user.id
    json.created @current_user.created_at
    json.updated @current_user.updated_at
    json.name    @current_user.name
    json.email   @current_user.email
  end
end