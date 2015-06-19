require 'rails_helper'
require 'json_expressions/rspec'

RSpec.describe "Join", :type => :request do
  include ApiHelper
  
  before(:each) do
    create_invitation    
    @header = {  "Contetnt-Type" => "application/json" }
    @token_header = { "Contetnt-Type" => "application/json", "X-Token" => @token }
    @owner_header = { "Contetnt-Type" => "application/json", "X-Token" => @owner_token }
    @target_header = { "Contetnt-Type" => "application/json", "X-Token" => @target_token }
    @joined_header = { "Contetnt-Type" => "application/json", "X-Token" => @joined_token }
  end
  
  describe 'GET /gruops/:group_name/join' do
    it '通常' do
      get "/api/v1/groups/#{@invitation.group.name}/join",
          {},
          @target_header
      
      expect(response.status).to eq 200
      
      json = JSON.parse(response.body)
      expect(json).to match_json_expression(json_common)
      expect(json["result"]).to match_json_expression(json_users)
    end
    
    it '認証失敗時' do
      get "/api/v1/groups/#{@invitation.group.name}/join",
          {},
          @header
      
      expect(response.status).to eq 401
      
      json = JSON.parse(response.body)
      expect(json).to match_json_expression(json_common)
      expect(json["result"]).to match_json_expression(json_error)
    end
    
    it '認証はできているが、グループに参加していない' do
      get "/api/v1/groups/#{@invitation.group.name}/join",
          {},
          @token_header
      
      expect(response.status).to eq 404
      
      json = JSON.parse(response.body)
      expect(json).to match_json_expression(json_common)
      expect(json["result"]).to match_json_expression(json_error)
    end
    
    it '該当グループが存在しない' do
      get "/api/v1/groups/error_group/join",
          {},
          @target_header
      
      expect(response.status).to eq 404
      
      json = JSON.parse(response.body)
      expect(json).to match_json_expression(json_common)
      expect(json["result"]).to match_json_expression(json_error)
    end
        
  end

  describe 'POST /gruops/:group_name/join/:user_name' do
    it '通常' do
      expect {
        post "/api/v1/groups/#{@invitation.group.name}/join/#{@invitation.target.name}",
             {},
             @target_header
      }.to change{ Invitation.count }.by(-1)
      
      expect(response.status).to eq 201
      
      json = JSON.parse(response.body)
      expect(json).to match_json_expression(json_common)
      
    end

    it '認証失敗時' do
      expect {
        post "/api/v1/groups/#{@invitation.group.name}/join/#{@invitation.target.name}",
             {},
             @header
      }.to change{ Invitation.count }.by(0)
      
      expect(response.status).to eq 401
      
      json = JSON.parse(response.body)
      expect(json).to match_json_expression(json_common)
    end

    it '認証はできているが、招待されていない' do
      expect {
        post "/api/v1/groups/#{@invitation.group.name}/join/#{@current_user.name}",
             {},
             @token_header
      }.to change{ Invitation.count }.by(0)
      
      expect(response.status).to eq 404
      
      json = JSON.parse(response.body)
      expect(json).to match_json_expression(json_common)
      
    end
    
    it '該当グループが存在しない' do
      expect {
        post "/api/v1/groups/error_group/join/#{@invitation.target.name}",
             {},
             @target_header
      }.to change{ Invitation.count }.by(0)
      
      expect(response.status).to eq 404
      
      json = JSON.parse(response.body)
      expect(json).to match_json_expression(json_common)
      
    end
    
    it '認証されたユーザーと、該当ユーザーが一致しない' do
      expect {
        post "/api/v1/groups/#{@invitation.group.name}/join/error_target",
             {},
             @target_header
      }.to change{ Invitation.count }.by(0)
      
      expect(response.status).to eq 404
      
      json = JSON.parse(response.body)
      expect(json).to match_json_expression(json_common)
      
    end
    
  end

  describe 'DELETE /groups/:group_name/join/:user_name' do
    it '通常' do
      expect {
        delete "/api/v1/groups/#{@group.name}/join/#{@joined_user.name}",
        {},
        @joined_header
      }.to change{ @group.users.count }.by(-1)

      expect(response.status).to eq 200
    end
    
    it '認証失敗時' do
      expect {
        delete "/api/v1/groups/#{@group.name}/join/#{@joined_user.name}",
        {},
        @header
      }.to change{ @group.users.count }.by(0)

      expect(response.status).to eq 401

      json = JSON.parse(response.body)
      expect(json).to match_json_expression(json_common)
    end

    it '認証はできているが、該当グループに参加していない' do
      expect {
        delete "/api/v1/groups/#{@group.name}/join/#{@current_user.name}",
        {},
        @token_header
      }.to change{ @group.users.count }.by(0)

      expect(response.status).to eq 404

      json = JSON.parse(response.body)
      expect(json).to match_json_expression(json_common)
    end
    
    it '該当グループが存在しない' do
      expect {
        delete "/api/v1/groups/error_group/join/#{@joined_user.name}",
        {},
        @joined_header
      }.to change{ @group.users.count }.by(0)

      expect(response.status).to eq 404

      json = JSON.parse(response.body)
      expect(json).to match_json_expression(json_common)
    end
    
    it '認証されたユーザーと、該当ユーザーが一致しない' do
      expect {
        delete "/api/v1/groups/#{@group.name}/join/error_name",
        {},
        @joined_header
      }.to change{ @group.users.count }.by(0)

      expect(response.status).to eq 404

      json = JSON.parse(response.body)
      expect(json).to match_json_expression(json_common)
    end
    
  end
  
end