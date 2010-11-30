# To change this template, choose Tools | Templates
# and open the template in the editor.

class ProfilesController < ApplicationController
  
  before_filter :init_profile, :action => [:show, :edit, :update, :destroy, :order_cartons]

  def index
    (current_user.is? :admin)? @profiles = User.all : @profiles = User.find_by_id(current_user.id)
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
    unless @profile.is_premium?
      @profile.destroy if @profile.is_destroyable?
      @profile.packages.each do |package|
        package.destroy if package.is_destroyable?
      end
      UserMailer.cancel_info(@profile).deliver
      redirect_to profiles_path, :notice => I18n.t(:profile_destroyed)
    else
      # Premium Account erst nach Ablauf der Mitgliedschaft löschen
      # die Kleiderpakete auch erst nach Ablauf der Mitgliedschaft löschen
    end
    
  end

  def search
    search_type, search_key = params[:search_type], params[:search_key]
    @profiles = User.search_by_attributes(search_key, search_type) unless search_type.nil? || search_key.nil?
  end

  def history
    @packages = self.user.packages
    @orders   = self.user.orders
  end

  # Neue Versandkartonage anfordern
  def order_cartons
    UserMailer.order_cartons(@profile).deliver
    redirect_to edit_profile_path(@profile)
  end

  private

    def init_profile
      init_current_object { @profile = User.find_by_id(params[:id]) }
    end

    def init_current_object
      @current_object = yield
    end
end
