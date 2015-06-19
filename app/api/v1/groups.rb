module V1
  class Groups < Grape::API
    resource :groups do
      
      # GET /api/v1/groups 
      get '', jbuilder: 'groups/index' do
        @groups = Group.all
      end
      
      # GET /api/v1/groups/:group_name
      params do
        requires :group_name, type: String
      end
      get ':group_name', jbuilder: 'groups/new' do
        @users = []
        @group = Group.where(name: params[:group_name]).first
        error!({code: 1, message: "NOT_FOUND", detail: {group_name: params[:group_name]}}, 404) unless @group.present?

        if authenticated?(headers)
          @users = @group.users if current_user.joined?(@group.name)
        end
      end
      
      # POST /api/v1/groups
      params do
        requires :group_name, type: String
      end
      post '', jbuilder: 'groups/new' do
        authenticated(headers)
        error({code: 4, message: "ALREADY_CREATED", detail: {group_name: params[:group_name]}}, 422) unless Group.available?(params)
        
        @group = Group.new(name: params[:group_name])
        @group.owner_id = current_user.id
        error!("グループの作成に失敗しました。") unless @group.save
      end
      
      # DELETE /api/v1/groups/:group_name
      params do
        requires :group_name, type: String
      end
      delete ':group_name', jbuilder: 'groups/delete' do
        authenticated(headers)
        @group = Group.where(name: params[:group_name]).first
        @owner = User.where(id: @group.owner_id).first unless @group.nil?
        
        error!({code: 1,
                message: "NOT_FOUND",
                detail: {group_name: params[:group_name]}}, 404) unless @group.present?
        
        error!({code: 2,
                message: "PERMISSION_DENIED",
                detail: {owner_name: @owner.name,
                         user_name: current_user.name}}, 401) unless @group.owner_id == current_user.id
        @group.destroy
        status 200
      end
      
    end
  end
end