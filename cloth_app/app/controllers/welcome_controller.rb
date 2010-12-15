class WelcomeController < ApplicationController
  include Cms

  def home
    @contents = get_content("Welcome")
  end

  def index
    flash.keep # Will persist all flash values. You can also use a key to keep only that value: flash.keep(:notice)
    redirect_to welcome_url
  end

  def membership
    @user = User.find_by_id(current_user.id)
  end

  # Methode: dashboard
  # Beschreibung: export aller Profile-Historien
  def dashboard

  end
  
end