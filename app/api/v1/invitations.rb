module V1
  class Invitations < Grape::API
    namespace 'groups/:group_name/invitations' do
      
      # GET /api/v1/groups/:group_name/invitations
      params do
        requires :group_name, type: String
      end
      get '', jbuilder: 'invitations/index' do
        authenticated(headers)
        @invitations = Invitation.search_by_group_name(params[:group_name]) if current_user.joined?(params[:group_name])
      end
      
      # GET /api/v1/groups/:group_id/invitations/:user_name
      params do
        requires :group_name, type: String
        requires :user_name,  type: String
      end
      get ':user_name', jbuilder: 'invitations/index' do
        authenticated(headers)
        @invitations = Invitation.where(target: params[:user_name],
                                        group_id: params[:group_id]) if current_user.joined?(params[:group_id])
        error!("該当グループに招待されているユーザははいません。") unless @invitations.present?
      end
      
      # POST /api/v1/groups/:group_name/invitations/:user_name
      params do
        requires :group_name, type: String
        requires :user_name,  type: String
      end
      post ':user_name', jbuilder: 'invitations/new' do
        authenticated(headers)
        @invitation = Invitation.new(owner: current_user.id,
                                     target: params[:user_name],
                                     group_id: params[:group_name]) if current_user.joined?(params[:group_id])
        error!("招待の作成に失敗しました。") unless @invitation.try(:save)
      end
      
      # DELETE /api/v1/groups/:group_name/invitations/:user_name
      params do
        requires :group_name, type: String
        requires :user_name,  type: String
      end
      delete ':user_name' do
        authenticated(headers)
        @invitation = Invitation.where(group_id: params[:group_name],
                                       target: params[:user_name]) if current_user.joined?(params[:group_name])
        error!("招待の作成に失敗しました。") unless @invitation.try(:destroy)
        status 200
      end
      
    end
  end
end