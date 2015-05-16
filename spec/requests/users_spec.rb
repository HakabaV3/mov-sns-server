require 'rails_helper'

RSpec.describe "Users", :type => :request do
  before do
    @user = create(:user, { name: "kikurage",
                            email: "kikurage@sample.com",
                            password: "kikurage_password"})
    @session = create(:session, { user_id: @user.id,
                                  token: "ksnao383290810yh48hn"})
    @header = {  "Contetnt-Type" => "application/json" }
    @token_header = { "Contetnt-Type" => "application/json", "X-Token" => @session.token }
  end
  
  it 'POST /api/v1/users' do
    params = { id: "jinssk@sample.com",
               password: "jinssk_password",
               name: "jinssk" }
    expect {
      post 'api/v1/users', params, @header
    }.to change{ User.count }.by(1)
    
    json = JSON.parse(response.body)
    expect(json["status"]).to eq("OK")
  end
  
  it 'PATCH /api/v1/users/:user_id' do
    path = "api/v1/users/#{@user.id}" 
    params = { name: "kikurage_updated"}
    token = @session.token
    
    patch path, params, @token_header
    
    expect(response.status).to eq 200
    
    json = JSON.parse(response.body)
    expect(json["result"]["user"]["name"]).to eq("kikurage_updated")
  end
  
  it 'DELETE /api/v1/users' do
    params = {}
    expect {
      delete 'api/v1/users', params, @token_header    
    }.to change{ User.count }.by(-1)
    
    expect(response.status).to eq 200
    
    json = JSON.parse(response.body)
    expect(json["status"]).to eq("OK")
  end
  
end