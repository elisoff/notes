class ApplicationController < ActionController::API
  before_filter :restrict_access

  include ActionController::RespondWith
  include ActionController::HttpAuthentication::Token::ControllerMethods
  
  private
  def restrict_access
    authenticate_or_request_with_http_token do |token, options|
      ApiKey.exists?(access_token: token)
      
      user = ApiKey.where(access_token: token).first.user
      
      session[:user_id] = user.id
    end
  end

end
