require 'rails_helper'
require 'json_expressions/rspec'

RSpec.describe "Invitations", :type => :request do
  include ApiHelper
  
  before(:each) do
    create_invitation    
    @header = {  "Contetnt-Type" => "application/json" }
    @token_header = { "Contetnt-Type" => "application/json", "X-Token" => @token }
    @owner_header = { "Contetnt-Type" => "application/json", "X-Token" => @owner_token }
    @target_header = { "Contetnt-Type" => "application/json", "X-Token" => @target_token }
  end
  
  describe 'GET /groups/:group_name/invitations' do
    it '通常' do
      get "/api/v1/groups/#{@invitation.group.name}/invitations", {}, @owner_header
      
      expect(response.status).to eq 200
    
      json = JSON.parse(response.body)
      expect(json).to match_json_expression(json_common)
    end
    
    it '該当グループが存在しない' do
      get "/api/v1/groups/error_group/invitations", {}, @owner_header
      
      expect(response.status).to eq 404
      
      json = JSON.parse(response.body)
      expect(json).to match_json_expression(json_common)
      expect(json["result"]).to match_json_expression(json_error)
    end
    
    it '認証失敗時' do
      get "/api/v1/groups/#{@invitation.group.name}/invitations", {}, @header
      
      expect(response.status).to eq 401
      
      json = JSON.parse(response.body)
      expect(json).to match_json_expression(json_common)
      expect(json["result"]).to match_json_expression(json_error)      
    end
    
    it '認証はできたが、該当グループに参加していない' do
      get "/api/v1/groups/#{@invitation.group.name}/invitations", {}, @token_header
      
      expect(response.status).to eq 404
      
      json = JSON.parse(response.body)
      expect(json).to match_json_expression(json_common)
      expect(json["result"]).to match_json_expression(json_error)
    end
    
  end
  
  describe 'GET /groups/:group_name/invitations/:user_name' do
    it '通常' do
      get "/api/v1/groups/#{@invitation.group.name}/invitations/#{@invitation.target.name}", {}, @owner_header
      
      expect(response.status).to eq 200
      
      json = JSON.parse(response.body)
      expect(json).to match_json_expression(json_common)
    end
    
    it '該当グループが存在しない' do
      get "/api/v1/groups/error_group/invitations/#{@invitation.target.name}", {}, @owner_header
      
      expect(response.status).to eq 404
      
      json = JSON.parse(response.body)
      expect(json).to match_json_expression(json_common)
      expect(json["result"]).to match_json_expression(json_error)
    end
    
    it '該当ターゲットが存在しない' do
      get "/api/v1/groups/#{@invitation.group.name}/invitations/error_target", {}, @owner_header
      
      expect(response.status).to eq 404
      
      json = JSON.parse(response.body)
      expect(json).to match_json_expression(json_common)
      expect(json["result"]).to match_json_expression(json_error)
    end
    
    it '認証失敗時' do
      get "/api/v1/groups/#{@invitation.group.name}/invitations/#{@invitation.target.name}", {}, @header
      
      expect(response.status).to eq 401
      
      json = JSON.parse(response.body)
      expect(json).to match_json_expression(json_common)
      expect(json["result"]).to match_json_expression(json_error)
    end
    
    it '認証はできたが、該当グループに参加していない' do
      get "/api/v1/groups/#{@invitation.group.name}/invitations/#{@invitation.target.name}", {}, @token_header
      
      expect(response.status).to eq 404
      
      json = JSON.parse(response.body)
      expect(json).to match_json_expression(json_common)
      expect(json["result"]).to match_json_expression(json_error)
    end
    
  end
  
  describe 'POST /groups/:group_name/invitations' do
    it '通常' do
      expect {
        post "/api/v1/groups/#{@invitation.group.name}/invitations",
             {user_name: @current_user.name},
             @owner_header
      }.to change{ Invitation.count }.by(1)
      
      expect(response.status).to eq 201
      
      json = JSON.parse(response.body)
      expect(json).to match_json_expression(json_common)
      expect(json["result"]).to match_json_expression(json_invitation(json["result"]))
    end
    
    it '該当グループが存在しない' do
      expect {
        post "/api/v1/groups/error_group/invitations",
             {user_name: @current_user.name},
             @owner_header
      }.to change{ Invitation.count }.by(0)
      
      expect(response.status).to eq 404
      
      json = JSON.parse(response.body)
      expect(json).to match_json_expression(json_common)
      expect(json["result"]).to match_json_expression(json_error)
    end
    
    it '該当ターゲットが存在しない' do
      expect {
        post "/api/v1/groups/error_group/invitations",
             {user_name: "error_target"},
             @owner_header
      }.to change{ Invitation.count }.by(0)
      
      expect(response.status).to eq 404
      
      json = JSON.parse(response.body)
      expect(json).to match_json_expression(json_common)
      expect(json["result"]).to match_json_expression(json_error)
    end
    
    it '認証失敗時' do
      expect {
        post "/api/v1/groups/#{@invitation.group.name}/invitations",
             {user_name: @current_user.name},
             @header
      }.to change{ Invitation.count }.by(0)

      
      expect(response.status).to eq 401
      
      json = JSON.parse(response.body)
      expect(json).to match_json_expression(json_common)
      expect(json["result"]).to match_json_expression(json_error)      
    end
    
    it '認証はできたが、該当グループに参加していない' do
      expect {
        post "/api/v1/groups/#{@invitation.group.name}/invitations",
             {user_name: @current_user.name},
             @token_header
      }.to change{ Invitation.count }.by(0)
      
      expect(response.status).to eq 404
      
      json = JSON.parse(response.body)
      expect(json).to match_json_expression(json_common)
      expect(json["result"]).to match_json_expression(json_error)
    end
    
  end
  
  describe 'DELETE /groups/:group_name/invitations/:user_name' do
    it '通常' do
      expect {
        delete "/api/v1/groups/#{@invitation.group.name}/invitations/#{@invitation.target.name}",
               {},
               @owner_header      
      }.to change{ Invitation.count }.by(-1)
      
      expect(response.status).to eq 200
    end
    
    it '該当グループが存在しない' do
      expect {
        delete "/api/v1/groups/error_group/invitations/#{@invitation.target.name}",
               {},
               @owner_header      
      }.to change{ Invitation.count }.by(0)
      
      expect(response.status).to eq 404
      
      json = JSON.parse(response.body)
      expect(json).to match_json_expression(json_common)
      expect(json["result"]).to match_json_expression(json_error)
    end
    
    it '該当ターゲットが存在しない' do
      expect {
        delete "/api/v1/groups/#{@invitation.group.name}/invitations/error_target",
               {},
               @owner_header
      }.to change{ Invitation.count }.by(0)
      
      expect(response.status).to eq 404
      
      json = JSON.parse(response.body)
      expect(json).to match_json_expression(json_common)
      expect(json["result"]).to match_json_expression(json_error)
    end
    
    it '認証失敗時' do
      expect {
        delete "/api/v1/groups/#{@invitation.group.name}/invitations/#{@invitation.target.name}",
               {},
               @header
      }.to change{ Invitation.count }.by(0)
      
      expect(response.status).to eq 401
      
      json = JSON.parse(response.body)
      expect(json).to match_json_expression(json_common)
      expect(json["result"]).to match_json_expression(json_error)
    end
    
    it '認証はできたが、該当グループに参加していない' do
      expect {
        delete "/api/v1/groups/#{@invitation.group.name}/invitations/#{@invitation.target.name}",
               {},
               @token_header
      }.to change{ Invitation.count }.by(0)
      
      expect(response.status).to eq 404
      
      json = JSON.parse(response.body)
      expect(json).to match_json_expression(json_common)
      expect(json["result"]).to match_json_expression(json_error)
    end
    
  end
  
end