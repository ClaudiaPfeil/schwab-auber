class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  protect_from_forgery
  before_filter :authenticate

  rescue_from CanCan::AccessDenied do |exception|
    #flash[:alert] = exception.message
    flash[:alert] = "Access denied!"
    redirect_to root_url
  end

  protected

    def authenticate
      authenticate_or_request_with_http_basic do |username, password|
        username == "admins" && password == "schwab&auber"
      end
    end
  
end
