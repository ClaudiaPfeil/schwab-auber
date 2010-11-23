# To change this template, choose Tools | Templates
# and open the template in the editor.

class ProfilesController < ApplicationController
  
  before_filter :init_profile, :action => [:show, :edit, :update, :destroy]

  def index
     current_user.is? :admin ? @profiles = User.all : @profiles = User.where(:state  => "active ")
  end

  def show; end

  def new
    @profile = User.new()
  end

  def create
    @profile = User.new(params[:profile])
    if @profile.save
      redirect_to profiles_path, :notice => I18n.t(:profile_created)
    else
      render :action => 'new', :notice => I18n.t(:profile_not_created)
    end
  end

  def update; end

  def destroy
    @profile.destroy if @profile.is_destroyable?
    redirect_to profiles_path, :notice => I18n.t(:profile_destroyed)
  end

  def search
    search_type, search_key = params[:search_type], params[:search_key]
    @profiles = User.search_by_attributes(search_key, search_type) unless search_type.nil? || search_key.nil?
  end

  def history
    @packages = self.user.packages
    @orders   = self.user.orders
    
  end

  private

    def init_profile
      init_current_object { @profile = User.find_by_id(params[:id]) }
    end

    def init_current_object
      @current_object = yield
    end
end
