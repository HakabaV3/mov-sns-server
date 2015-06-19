module V1
  class Sessions < Grape::API
    resource :sessions do
      
      # POST api/v1/sessions/email
      params do
        requires :email,         type: String
        requires :password,   type: String
      end
      post '/email', jbuilder: 'sessions/new' do
        @user = User.where(email: params[:id]).first
        if !@user || !@user.try(:valid_password?, params[:password])
          error!({code: 3, message: "INVALID_PARAMETER", detail: {email: params[:email], password: ""}}, 401)
        end
        set_data(@user)
      end
      
      # POST /api/v1/sessions/refresh
      post '/refresh', jbuidler: 'sessions/new' do
        authenticated(headers)
        @user = current_user
        set_data(@user)
      end
      
      # DELETE api/v1/sessions
      delete '', jbuilder: 'sessions/delete' do
        authenticated(headers)
        Session.destroy_session(current_user)
        status 200
      end
      
    end
  end
end