module V1
  class Joins < Grape::API
    namespace 'groups/:group_id/join' do
      
      # GET /api/v1/groups/:group_id/join
      params do
        requires :group_id, type: Integer
      end
      get '', jbuilder: 'joins/index' do
        authenticated(headers)
        @group = Group.where(id: params[:group_id]).first  if current_user.joined?(params[:group_id])
        error!("グループ参加者の取得に失敗しました。") unless @group.present?
      end
      
      # POST /api/v1/groups/:group_id/join/:user_id
      params do
        requires :group_id, type: Integer
        requires :user_id,  type: Integer
      end
      post ':user_id', jbuilder: 'joins/new' do
        authenticated(headers)
        if current_user.id == params[:user_id] && current_user.has_invited?(params[:group_id])
          current_user.join_group(params[:group_id])
        elsif currnet_user.joined?(params[:group_id])
          error!("既にグループに参加しています。")
        else
          error!("グループへの参加に失敗しました。")
        end
      end
      
      # DELETE /api/v1/groups/:group_id/join/:user_id
      params do
        requires :group_id, type: Integer
        requires :user_id,  type: Integer
      end
      delete ':user_id' do
        authenticated(headers)
        if current_user.id == params[:user_id] && current_user.joined?(params[:group_id])
          error!("グループからの退会に失敗しました。") unless currnt_user.leave_group(params[:group_id])
        else
          error!("グループからの退会に失敗しました。")
        end
        status 200 
      end
      
    end
  end
end