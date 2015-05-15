class API < Grape::API

  prefix 'api'

  version 'v1', :using => :path

  format :json
  formatter :json, Grape::Formatter::Jbuilder

  helpers do
    def authenticated(headers)
      if token = headers["X-Token"]
        @session = Session.where(token: token).first
        if session
          @current_user = User.where(id: @session.user_id).first
        end
      end
      error!("401 Unauthorized", 401) unless current_user
    end
    
    def set_token
      header "X-Token", "#{current_user.token}"
    end
    
    def set_data(user)
      @current_user = user
      @session = Session.create_session(current_user)
      set_token
    end
    
    def current_user
      return @current_user
    end
  end

  mount V1::Root

end