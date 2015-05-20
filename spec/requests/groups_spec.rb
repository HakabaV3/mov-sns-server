require 'rails_helper'

RSpec.describe "Groups", :type => :request do
  
  before do
    @user = create(:user)
    @hakaba = create(:group)
    @session = create(:session, { user_id: @user.id,
                                  token: "ksnao383290810yh48hn"})
    @owner_session = create(:session, { user_id: 100,
                                        token: "ownerownerownerowner"})
    
    @header = {  "Contetnt-Type" => "application/json" }
    @token_header = { "Contetnt-Type" => "application/json", "X-Token" => @session.token }
    @owner_header = { "Contetnt-Type" => "application/json", "X-Token" => @owner_session.token }
  end
  
  describe 'GET /groups' do
    it '通常' do
      get '/api/v1/groups', {}
      
      expect(response.status).to eq 200
      
      json = JSON.parse(response.body)
      expect(json["status"]).to eq("OK")
    end
  end
  
  describe 'GET /groups/:group_name' do
    it '通常' do
      @hakaba.users << @user
      
      get 'api/v1/groups/Hakaba', {}, @token_header
      
      expect(response.status).to eq 200
      
      json = JSON.parse(response.body)
      expect(json["result"]["users"].count).to be > 0
    end
    
    it '認証はできたが、グループに参加していない' do
      get 'api/v1/groups/Hakaba', {}, @token_header
      
      expect(response.status).to eq 200
      
      json = JSON.parse(response.body)
      expect(json["result"]["users"].count).to eq 0
    end
    
    it '認証失敗' do
      get 'api/v1/groups/Hakaba', {}, @header
      
      expect(response.status).to eq 200
      
      json = JSON.parse(response.body)
      expect(json["result"]["users"].count).to eq 0
    end
    
  end
  
  describe 'POST /groups' do
    it '通常' do    
      expect {
        post 'api/v1/groups', { group_name: "BasketBallClub" }, @token_header        
      }.to change{ Group.count }.by(1)
      
      expect(response.status).to eq 201
      
      json = JSON.parse(response.body)
      expect(json["status"]).to eq("OK")      
    end
    
    it '認証失敗時' do
      expect {
        post 'api/v1/groups', { group_name: "BasketBallClub" }, @header        
      }.to change{ Group.count }.by(0)
      
      expect(response.status).to eq 401
      
      json = JSON.parse(response.body)
      expect(json["result"]["type"]).to eq("PERMISSION_DENIED")
    end
  end
  
  describe 'DELETE /groups/:group_name' do
    it '通常' do
      expect {
        delete '/api/v1/groups/Hakaba', {}, @owner_header      
      }.to change{ Group.count }.by(-1)
      
      expect(response.status).to eq 200
      
      json = JSON.parse(response.body)
      expect(json["status"]).to eq("OK")
    end
    
    it '認証失敗時' do
      expect {
        delete '/api/v1/groups/Hakaba', {}, @header      
      }.to change{ Group.count }.by(0)
      
      expect(response.status).to eq 401
      
      json = JSON.parse(response.body)
      expect(json["result"]["type"]).to eq("PERMISSION_DENIED")
    end
    
    it '認証はできたが、該当グループのオーナーではない' do
      expect {
        delete '/api/v1/groups/Hakaba', {}, @token_header      
      }.to change{ Group.count }.by(0)
      
      expect(response.status).to eq 401
      
      json = JSON.parse(response.body)
      expect(json["result"]["type"]).to eq("PERMISSION_DENIED")
    end
    
  end
  
end