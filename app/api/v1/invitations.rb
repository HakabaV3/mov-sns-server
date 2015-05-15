module V1
  class Invitations < Grape::API
    namespace 'groups/:group_id/invitations' do
      
      # GET /api/v1/groups/:group_id/invitations
      params do
        requires :group_id, type: Integer
      end
      get '', jbuilder: 'invitations/index' do
        authenticated(headers)
        @invitations = Invitation.where(group_id: params[:group_id]) if current_user.joined?(params[:group_id])
        error!("該当グループに招待されているユーザははいません。") unless @invitations.present?
      end
      
      # GET /api/v1/groups/:group_id/invitations/:user_id
      params do
        requires :group_id, type: Integer
        requires :user_id, type: Integer
      end
      get ':user_id', jbuilder: 'invitations/index' do
        authenticated(headers)
        @invitations = Invitation.where(target: params[:user_id], group_id: params[:group_id]) if current_user.joined?(params[:group_id])
        error!("該当グループに招待されているユーザははいません。") unless @invitations.present?
      end
      
      # POST /api/v1/groups/:group_id/invitations/:user_id
      params do
        requires :group_id, type: Integer
        requires :user_id, type: Integer
      end
      post ':user_id', jbuilder: 'invitations/new' do
        authenticated(headers)
        @invitation = Invitation.new(owner: current_user.id,
                                     target: params[:user_id],
                                     group_id: params[:group_id]) if current_user.joined?(params[:group_id])
        error!("招待の作成に失敗しました。") unless @invitation.try(:save)
      end
      
      # DELETE /api/v1/groups/:group_id/invitations/:user_id
      params do
        requires :group_id, type: Integer
        requires :user_id, type: Integer
      end
      delete ':user_id' do
        authenticated(headers)
        @invitation = Invitation.where(group_id: params[:group_id], target: params[:user_id]) if current_user.joined?(params[:group_id])
        error!("招待の作成に失敗しました。") unless @invitation.try(:destroy)
        status 200
      end
      
    end
  end
end