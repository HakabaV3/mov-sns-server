json.status "OK"
json.set! :result do
  json.array! @invitations do |invitation|
    json.id         invitation.id
    json.created_at invitation.created_at
    json.set! :owner do
      json.id    invitation.owner.id
      json.name  invitation.owner.name
      json.email invitation.owner.email
    end
    json.set! :target do
      json.id    invitation.target.id
      json.name  invitation.target.name
      json.email invitation.target.email
    end
  end
end