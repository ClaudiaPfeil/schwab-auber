class LoginsController < ApplicationController
  before_filter :init_login, :action => {:show, :edit, :update, :destroy}
  session :on

  def index
    @logins = Login.all
  end

  def new
    @login = Login.new()
  end

  # "Create" a login, aka "log the user in"
  def create
    if customer = Customer.authenticate(params[:login], params[:password])
      # Save the user ID in the session so it can be used in subsequent requests
      session[:current_user_id] = customer.id
      redirect_to root_url
    end
  end

  # "Delete" a login, aka "log the user out"
  def destroy
    # Remove the user id from the session
    session[:current_user_id] = nil
    flash[:notice] = "You have successfully logged out" 
    redirect_to root_url
  end

  private
    def init_login
      init_current_object { @login = Login.find_by_id(params[:id])}
    end

    def init_current_object
      @current_object = yield
    end
  
end
