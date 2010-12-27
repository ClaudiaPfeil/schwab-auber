# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  include Cms
  include CanCan::Ability
  include AuthenticatedSystem
  
  # render new.rhtml
  def new
    @contents = get_content("Login")
  end

  def create
    logout_keeping_session!
    user = User.authenticate(params[:login], params[:password])
    if user
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_user = user
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      current_user.is_premium? ? (redirect_to search_packages_path, :notice => "Login erfolgreich.") : (redirect_to membership_path, :notice => "Login erfolgreich.")
      #redirect_back_or_default('/', :notice => "Logged in successfully")
    else
      note_failed_signin
      @login       = params[:login]
      @remember_me = params[:remember_me]
      render :action => 'new'
    end
  end

  def destroy
    logout_killing_session!
    redirect_back_or_default('/', :notice => "Sie wurden erfolgreich ausgeloggt.")
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash.now[:error] = "Leider konnten sie nicht as '#{params[:login]}' angemeldet werden."
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end


end
