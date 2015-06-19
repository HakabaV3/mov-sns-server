module V1
  class Joins < Grape::API
    namespace 'groups/:group_name/join' do
      
      # GET /api/v1/groups/:group_name/join
      params do
        requires :group_name, type: String
      end
      get '', jbuilder: 'joins/index' do
        authenticated(headers)
        error!({code: 1, message: "NOT_FOUND", detail: {user_name: current_user.name}}, 404) unless current_user.joined?(params[:group_name])
        
        @group = Group.where(name: params[:group_name]).first
        error!({code: 1, message: "NOT_FOUND", detail: {group_name: params[:group_name]}}, 404) unless @group.present?
      end
      
      # POST /api/v1/groups/:group_name/join/:user_name
      params do
        requires :group_name, type: String
        requires :user_name,  type: String
      end
      post ':user_name', jbuilder: 'joins/new' do
        authenticated(headers)
        @current_user = current_user
        error!({code: 1, message: "NOT_FOUND", detail: {}}, 404) unless @current_user.has_invited?(params[:group_name])
        error!({code: 1, message: "NOT_FOUND", detail: {}}, 404) unless @current_user.name == params[:user_name] 
        
        @current_user.join_group(params[:group_name])
      end
      
      # DELETE /api/v1/groups/:group_name/join/:user_name
      params do
        requires :group_name, type: String
        requires :user_name,  type: String
      end
      delete ':user_name' do
        authenticated(headers)
        @current_user = current_user
        error!({code: 1, message: "NOT_FOUND", detail: {}}, 404) unless @current_user.has_invited?(params[:group_name])
        error!({code: 1, message: "NOT_FOUND", detail: {}}, 404) unless @current_user.name == params[:user_name] 

        @current_user.leave_group(params[:group_name])
        status 200 
      end
      
    end
  end
end