module V1
  class Users < Grape::API
    resource :users do
      
      helpers do
        def validation_params(params)
          detail = {}
          detail[:email] = params[:email] unless User.where(email: params[:email]).count == 0
          detail[:name] = params[:name] unless User.where(name: params[:name]).count == 0
          
          if detail[:email] || detail[:name]
            error!({ code: 4, message: "ALREADY_USED", detail: detail})
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
        if @user.save
          set_data(@user)
        else
          error!({ code: 4, message: "FAILED_TO_CREATE", detail: params })
        end
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
        error!({code: 4, message: "NOT_MATCH_USER_NAME", detail: {name: params[:user_name]}}, 401) unless current_user.name == params[:user_name]
        
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
        error!({code: 4, message: "NOT_MATCH_USER_NAME", detail: {name: params[:user_name]}}, 401) unless current_user.name == params[:user_name]
        
        @user = current_user
        @user.destroy
      end
      
    end
  end
end