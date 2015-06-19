require 'rails_helper'
require 'json_expressions/rspec'

RSpec.describe "Groups", :type => :request do
  include ApiHelper
  
  before do
    create_group
    
    @header = { "Contetnt-Type" => "application/json" }
    @token_header = { "Contetnt-Type" => "application/json", "X-Token" => @token }
    @owner_header = { "Contetnt-Type" => "application/json", "X-Token" => @owner_token }
  end
  
  describe 'GET /groups' do
    it '通常' do
      get '/api/v1/groups'
      
      expect(response.status).to eq 200
      
      json = JSON.parse(response.body)
      expect(json["status"]).to eq("OK")
    end
  end
  
  describe 'GET /groups/:group_name' do
    it '通常' do      
      get "api/v1/groups/#{@group.name}", {}, @owner_header
      
      expect(response.status).to eq 200
      
      json = JSON.parse(response.body)
      expect(json).to match_json_expression(json_common)
    end
    
    it '認証はできたが、グループに参加していない' do
      get "api/v1/groups/#{@group.name}", {}, @token_header
      
      expect(response.status).to eq 200
      
      json = JSON.parse(response.body)
      expect(json["result"]["users"].count).to eq 0
    end
    
    it '認証失敗' do
      get "api/v1/groups/#{@group.name}", {}, @header
      
      expect(response.status).to eq 200
      
      json = JSON.parse(response.body)
      expect(json).to match_json_expression(json_common)
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
      expect(json).to match_json_expression(json_common)      
    end
    
    it '認証失敗時' do
      expect {
        post 'api/v1/groups', { group_name: "BasketBallClub" }, @header        
      }.to change{ Group.count }.by(0)
      
      expect(response.status).to eq 401
      
      json = JSON.parse(response.body)
      expect(json).to match_json_expression(json_common)
      expect(json["result"]).to match_json_expression(json_error)
    end
  end
  
  describe 'DELETE /groups/:group_name' do
    it '通常' do
      expect {
        delete "api/v1/groups/#{@group.name}", {}, @owner_header      
      }.to change{ Group.count }.by(-1)
      
      expect(response.status).to eq 200
    end
    
    it 'グループ名が存在しない' do
      expect {
        delete 'api/v1/groups/abcdefg', {}, @owner_header
      }.to change{ Group.count }.by(0)
      
      expect(response.status).to eq 404
      
      json = JSON.parse(response.body)
      expect(json).to match_json_expression(json_common)
      expect(json["result"]).to match_json_expression(json_error)
    end
    
    it '認証失敗時' do
      expect {
        delete "api/v1/groups/#{@group.name}", {}, @header      
      }.to change{ Group.count }.by(0)
      
      expect(response.status).to eq 401
      
      json = JSON.parse(response.body)
      expect(json).to match_json_expression(json_common)
      expect(json["result"]).to match_json_expression(json_error)
    end
    
    it '認証はできたが、該当グループのオーナーではない' do
      expect {
        delete "api/v1/groups/#{@group.name}", {}, @token_header      
      }.to change{ Group.count }.by(0)
      
      expect(response.status).to eq 401
      
      json = JSON.parse(response.body)
      expect(json).to match_json_expression(json_common)
      expect(json["result"]).to match_json_expression(json_error)
    end
    
  end
end