module V1
  class Users < Grape::API
    resource :users do
      
      helpers do
        def validation_params(params)
          detail = User.is_used(params)
          if detail[:email] || detail[:name]
            error!({ code: 4, message: "ALREADY_CREATED", detail: detail}, 401)
          end
        end
      end
      
      # POST /api/v1/users
      params do
        requires :email,    type: String
        requires :password, type: String
        requires :name,     type: String
      end
      post '', jbuilder: 'sessions/new' do
        validation_params(params)
        @user = User.new(
          email: params[:email],
          name: params[:name],
          password: params[:password],
          password_confirmation: params[:password]
        )
        @user.save
        set_data(@user)
      end
      
      # PATCH /api/v1/users/:user_name (private)
      params do
        requires :user_name, type: String
        optional :user_id,   type: Integer
        optional :password,  type: String
        optional :name,      type: String
      end
      patch ':user_name', jbuilder: "sessions/new" do
        authenticated(headers)
        error!({code: 1, message: "NOT_FOUND", detail: {name: params[:user_name]}}, 401) unless current_user.name == params[:user_name]
        
        @user = current_user
        @user.update_data!(params)
        set_data(@user)
      end
      
      # DELETE /api/v1/users/:user_name (private)
      params do
        requires :user_name, type: String
      end
      delete ':user_name', jbuilder: 'sessions/delete' do
        authenticated(headers)
        error!({code: 1, message: "NOT_FOUND", detail: {name: params[:user_name]}}, 401) unless current_user.name == params[:user_name]
        
        @user = current_user
        @user.destroy
      end
      
    end
  end
end