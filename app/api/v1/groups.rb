module V1
  class Groups < Grape::API
    resource :groups do
      
      # GET /api/v1/groups 
      get '', jbuilder: 'groups/index' do
        authenticated(headers)
        @groups = Group.where(user_id: current_user.id)
      end
      
      # GET /api/v1/groups/:id
      params do
        requires :name, type: String
      end
      get ':name', jbuilder: 'groups/new' do
        authenticated(headers)
        @group = current_user.groups.where(name: params[:name])
        error!("該当するグループが見つかりません。") unless @group.present?
      end
      
      # POST /api/v1/groups
      params do
        requires :name, type: String
      end
      post '', jbuilder: 'groups/new' do
        authenticated(headers)
        @group = Group.new(name: params[:name])
        @group.owner_id = current_user.id
        error!("グループの作成に失敗しました。") unless @group.save
      end
      
      # DELETE /api/v1/groups/:id
      params do
        requires :name, type: String
      end
      delete ':name' do
        authenticated(headers)
        @group = current_user.groups.where(name: params[:name])
        error!("該当グループの削除に失敗しました。") unless @group.destroy
        status 200
      end
      
    end
  end
end