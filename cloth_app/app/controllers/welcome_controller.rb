class WelcomeController < ApplicationController

  def home
    category = Category.find_by_name("Welcome")
    @welcome = category.contents
  end

  def index
    flash.keep # Will persist all flash values. You can also use a key to keep only that value: flash.keep(:notice)
    redirect_to welcome_url
  end
  
end