json.status "OK"
json.set! :result do
  json.id @invitation.id
  json.created @invitation.created_at
  json.updated @invitation.updated_at
  json.set! :target do
    json.id @invitation.target.id
    json.name @invitation.target.name
    json.email @invitation.target.email
  end
  json.set! :owner do
    json.id @invitation.owner.id
    json.name @invitation.owner.name
    json.email @invitation.owner.email
  end
end