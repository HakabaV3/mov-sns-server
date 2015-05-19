require 'rails_helper'

RSpec.describe "Users", :type => :request do
  before do
    @user = create(:user, { id: 100,
                            name: "kikurage",
                            email: "kikurage@sample.com",
                            password: "kikurage_password"})
    @session = create(:session, { user_id: @user.id,
                                  token: "ksnao383290810yh48hn"})
    @header = {  "Contetnt-Type" => "application/json" }
    @token_header = { "Contetnt-Type" => "application/json", "X-Token" => @session.token }
  end
  
  describe 'POST /api/v1/users' do
    it '通常' do
      expect {
        post 'api/v1/users', { email: "stogu@sample.com",
                               password: "stogu_password",
                               name: "stogu" }, @header
      }.to change{ User.count }.by(1)
    
      json = JSON.parse(response.body)
      Rails.logger.debug json
      expect(json["status"]).to eq("OK")
    end
    
    it '"id"が指定されていない' do
      expect {
        post 'api/v1/users', { password: "stogu_password",
                               name: "stogu" }, @header
      }.to change{ User.count }.by(0)      
      
      json = JSON.parse(response.body)
      expect(json["status"]).to eq("NG")
    end
    
    it '"password"が指定されていない' do
      expect {
        post 'api/v1/users', { email: "stogu@smaple.com",
                               name: "stogu"}
      }.to change{ User.count}.by(0)
      
      json = JSON.parse(response.body)
      expect(json["status"]).to eq("NG")
    end
    
    it '"name"が指定されていない' do
      expect {
        post 'api/v1/users', { email: "stogu@sample.com",
                               password: "stogu_password"}
      }.to change{ User.count }.by(0)
      
      json = JSON.parse(response.body)
      expect(json["status"]).to eq("NG")
    end
    
    it '"email"が既に使用されている' do
      expect {
        post 'api/v1/users', { email: "kikurage@sample.com",
                               password: "kikurage_password",
                               name: "kikurage"}
      }.to change{ User.count }.by(0)
      
      json = JSON.parse(response.body)
      expect(json["result"]["type"]).to eq("ALREADY_USED")
    end
  end
  
  describe 'PATCH /api/v1/users/:user_name' do
    before do
      @path = "api/v1/users/#{@user.name}" 
      @params = { name: "kikurage_updated" }
      @token = @session.token
    end
    
    it '通常' do
      patch @path, @params, @token_header
  
      expect(response.status).to eq 200
    
      json = JSON.parse(response.body)
      expect(json["result"]["user"]["name"]).to eq("kikurage_updated")
    end
    
    it 'X-Tokenが存在しない' do
      patch @path, @params, @header
      expect(response.status).to eq 401
      
      json = JSON.parse(response.body)
      expect(json["result"]["type"]).to eq("PERMISSION_DENIED")
    end
    
    it 'X-Tokenが空' do
      patch @path, @params, { "Contetnt-Type" => "application/json", "X-Token" => "" }
      expect(response.status).to eq 401
      
      json = JSON.parse(response.body)
      expect(json["result"]["type"]).to eq("PERMISSION_DENIED")
    end
    
    it 'X-Tokenが間違っている' do
      patch @path, @params,
             { "Contetnt-Type" => "application/json",
               "X-Token" => "wrong_token" }
      expect(response.status).to eq 401
      
      json = JSON.parse(response.body)
      expect(json["result"]["type"]).to eq("PERMISSION_DENIED")
    end
    
    it '認証しているが他人を編集しようとした' do
      patch "api/v1/users/stogu", @params, @token_header
      expect(response.status).to eq 401
      
      json = JSON.parse(response.body)
      expect(json["result"]["type"]).to eq("NOT_MATCH_USER_NAME")
    end
    
  end
  
  describe 'DELETE /api/v1/users/:name' do
    it '通常' do
      params = {}
      expect {
        delete 'api/v1/users/kikurage', params, @token_header    
      }.to change{ User.count }.by(-1)
    
      expect(response.status).to eq 200
      
      json = JSON.parse(response.body)
      expect(json["status"]).to eq("OK")
    end
    
    it '認証しているが他人を編集しようとした' do
      params = {}
      expect {
        delete 'api/v1/users/stogu', params, @token_header
      }.to change{ User.count }.by(0)
      
      expect(response.status).to eq 401
      
      json = JSON.parse(response.body)
      expect(json["result"]["type"]).to eq("NOT_MATCH_USER_NAME")
    end
    
  end
  
end