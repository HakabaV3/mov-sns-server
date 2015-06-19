require 'rails_helper'
require 'json_expressions/rspec'

RSpec.describe "Users", :type => :request do
  include ApiHelper
  
  before(:each) do
    create_token
    @header = {  "Contetnt-Type" => "application/json" }
    @token_header = { "Contetnt-Type" => "application/json", "X-Token" => @token }
  end
  
  describe 'POST /api/v1/users' do
    before do
      @path = "/api/v1/users/#{@current_user.name}"
    end
    
    it '通常' do
      expect {
        post 'api/v1/users', { email: "stogu@sample.com",
                               password: "stogu_password",
                               name: "stogu" }, @header
      }.to change{ User.count }.by(1)
      
      expect(response.status).to eq 201
      
      json = JSON.parse(response.body)
      expect(json).to match_json_expression(json_common)
      expect(json["result"]).to match_json_expression(json_session(json["result"]))
    end
    
    it '"id"が指定されていない' do
      expect {
        post 'api/v1/users', { password: "stogu_password",
                               name: "stogu" }, @header
      }.to change{ User.count }.by(0)      
      
      expect(response.status).to eq 400
      
      json = JSON.parse(response.body)
      expect(json).to match_json_expression(json_common)
      expect(json["result"]).to match_json_expression(json_error)
    end
    
    it '"password"が指定されていない' do
      expect {
        post 'api/v1/users', { email: "stogu@smaple.com",
                               name: "stogu"}
      }.to change{ User.count}.by(0)
      
      expect(response.status).to eq 400
      
      json = JSON.parse(response.body)
      expect(json).to match_json_expression(json_common)
      expect(json["result"]).to match_json_expression(json_error)
    end
    
    it '"name"が指定されていない' do
      expect {
        post 'api/v1/users', { email: "stogu@sample.com",
                               password: "stogu_password"}
      }.to change{ User.count }.by(0)
      
      expect(response.status).to eq 400
      
      json = JSON.parse(response.body)
      expect(json).to match_json_expression(json_common)
      expect(json["result"]).to match_json_expression(json_error)
    end
    
    it '"email"が既に使用されている' do
      expect {
        post 'api/v1/users', { email: @current_user.email,
                               password: "kikurage_password",
                               name: "kikurage"}
      }.to change{ User.count }.by(0)
      
      expect(response.status).to eq 401
      
      json = JSON.parse(response.body)
      expect(json).to match_json_expression(json_common)
      expect(json["result"]).to match_json_expression(json_error)
    end
  end
  
  describe 'PATCH /api/v1/users/:user_name' do
    before do
      @path = "api/v1/users/#{@current_user.name}" 
      @params = { name: "kikurage_updated" }
    end
    
    it '通常' do
      patch @path, @params, @token_header
  
      expect(response.status).to eq 200
    
      json = JSON.parse(response.body)
      expect(json).to match_json_expression(json_common)
      expect(json["result"]).to match_json_expression(json_session(json["result"]))
    end
    
    it 'X-Tokenが存在しない' do
      patch @path, @params, @header
      expect(response.status).to eq 401
      
      json = JSON.parse(response.body)
      expect(json).to match_json_expression(json_common)
      expect(json["result"]).to match_json_expression(json_error)
    end
    
    it 'X-Tokenが空' do
      patch @path, @params, { "Contetnt-Type" => "application/json", "X-Token" => "" }
      expect(response.status).to eq 401
      
      json = JSON.parse(response.body)
      expect(json).to match_json_expression(json_common)
      expect(json["result"]).to match_json_expression(json_error)
    end
    
    it 'X-Tokenが間違っている' do
      patch @path, @params,
             { "Contetnt-Type" => "application/json",
               "X-Token" => "wrong_token" }
      expect(response.status).to eq 401
      
      json = JSON.parse(response.body)
      expect(json).to match_json_expression(json_common)
      expect(json["result"]).to match_json_expression(json_error)
    end
    
    it '認証しているが他人を編集しようとした' do
      patch "api/v1/users/stogu", @params, @token_header
      expect(response.status).to eq 401
      
      json = JSON.parse(response.body)
      expect(json).to match_json_expression(json_common)
      expect(json["result"]).to match_json_expression(json_error)
    end
    
  end
  
  describe 'DELETE /api/v1/users/:name' do
    before do
      @path = "/api/v1/users/#{@current_user.name}"
    end
    
    it '通常' do
      params = {}
      expect {
        delete @path, params, @token_header    
      }.to change{ User.count }.by(-1)
    
      expect(response.status).to eq 200
    end
    
    it '認証しているが他人を編集しようとした' do
      params = {}
      expect {
        delete 'api/v1/users/stogu', params, @token_header
      }.to change{ User.count }.by(0)
      
      expect(response.status).to eq 401
      
      json = JSON.parse(response.body)
      expect(json).to match_json_expression(json_common)
      expect(json["result"]).to match_json_expression(json_error)
    end
    
  end
  
end