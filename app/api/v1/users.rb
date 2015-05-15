module V1
  class Users < Grape::API
    resource :users do
      
      # POST /api/v1/users
      params do
        requires :id,       type: String
        requires :password, type: String
        requires :name,     type: String
      end
      post '', jbuilder: 'sessions/new' do
        @user = User.new(
          email: params[:id],
          name: params[:name],
          password: params[:password],
          password_confirmation: params[:password]
        )
        if @user.save
          set_data(@user)
        else
          error!("ユーザー作成に失敗しました。")
        end
      end
      
      # PATCH /api/v1/users
      params do
        optional :user_id,       type: String
        optional :password, type: String
        optional :name,     type: String
      end
      patch ':user_id', jbuilder: "sessions/new" do
        authenticated(headers)
        @user = current_user
        if @user.update_data(params[:email], params[:password], params[:name])
          set_data(@user)
        else
          error!("ユーザー更新に失敗しました。")
        end
      end
      
      # DELETE /api/v1/users
      delete '', jbuilder: 'sessions/delete' do
        authenticated(headers)
        @user = current_user
        error!("ユーザー削除に失敗しました。") if !@user.destroy
      end
      
    end
  end
end