json.status    "OK"
json.set! :result do
  json.id      @session.id
  json.created @session.created_at
  json.updated @session.updated_at
  json.set! :user do
    json.id    @user.id
    json.name  @user.name
    json.email @user.email
  end
  json.token   @session.token
end