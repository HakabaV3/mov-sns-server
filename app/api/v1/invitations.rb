module V1
  class Invitations < Grape::API
    namespace 'groups/:group_name/invitations' do
      
      # GET /api/v1/groups/:group_name/invitations
      params do
        requires :group_name, type: String
      end
      get '', jbuilder: 'invitations/index' do
        authenticated(headers)
        error!({code: 1, message: "NOT_FOUND", detail:{}}, 404) unless current_user.joined?(params[:group_name])
        
        @invitations = Invitation.search_by_group_name(params[:group_name])
      end
      
      # GET /api/v1/groups/:group_id/invitations/:user_name
      params do
        requires :group_name, type: String
        requires :user_name,  type: String
      end
      get ':user_name', jbuilder: 'invitations/new' do
        authenticated(headers)
        error!({code: 1, message: "NOT_FOUND", detail:{group_name: params[:group_name]}}, 404) unless current_user.joined?(params[:group_name])
        
        @invitation = Invitation.search_by_params(params)
        error!({code: 1, message: "NOT_FOUND", detail:{user_name: params[:user_name]}}, 404) unless @invitation.present?
      end
      
      # POST /api/v1/groups/:group_name/invitations
      params do
        requires :group_name, type: String
        requires :user_name,  type: String
      end
      post '', jbuilder: 'invitations/new' do
        authenticated(headers)
        error!({code: 1, message: "NOT_FOUND", detail: {group_name: params[:group_name]}}, 404) unless @group = Group.search_by_name(params[:group_name])
        error!({code: 1, message: "NOT_FOUND", detail: {user_name: params[:user_name]}}, 404) unless @target = User.search_by_name(params[:user_name])
        error!({code: 1, message: "NOT_FOUND", detail: {user_name: current_user.name}}, 404) unless current_user.joined?(params[:group_name])
        
        @invitation = Invitation.new(owner_id: current_user.id,
                                     target_id: @target.id,
                                     group_id: @group.id)
        @invitation.save
      end
      
      # DELETE /api/v1/groups/:group_name/invitations/:user_name
      params do
        requires :group_name, type: String
        requires :user_name,  type: String
      end
      delete ':user_name', jbuilder: 'invitations/delete' do
        authenticated(headers)
        error!({code: 1, message: "NOT_FOUND", detail: {group_name: params[:group_name]}}, 404) unless Group.search_by_name(params[:group_name])
        error!({code: 1, message: "NOT_FOUND", detail: {user_name: params[:user_name]}}, 404) unless User.search_by_name(params[:user_name])
        error!({code: 1, message: "NOT_FOUND", detail: {user_name: current_user.name}}, 404) unless current_user.joined?(params[:group_name])
        
        @invitation = Invitation.search_by_params(params)
        @invitation.destroy
        status 200
      end
      
    end
  end
end