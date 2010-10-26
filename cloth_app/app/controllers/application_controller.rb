class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    #flash[:alert] = exception.message
    flash[:alert] = "Access denied!"
    redirect_to root_url
  end
  
end
