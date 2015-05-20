class API < Grape::API

  prefix 'api'

  version 'v1', :using => :path

  format :json
  formatter :json, Grape::Formatter::Jbuilder
  error_formatter :json, Formatter::Error
  
  helpers do
    def authenticated(headers)
      if token = headers["X-Token"]
        @session = Session.where(token: token).first
        if @session
          @current_user = User.where(id: @session.user_id).first
        end
      end
      error!({ :code => 4, :message => "PERMISSION_DENIED", :detail => {} }, 401) unless current_user
    end
    
    def authenticated?(headers)
      return false if headers["X-Token"].nil?
      
      @session = Session.where(token: headers["X-Token"]).first
      if @session
        @current_user = User.where(id: @session.user_id).first
        return true
      end
      return false
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