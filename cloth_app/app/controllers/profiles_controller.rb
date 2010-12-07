# To change this template, choose Tools | Templates
# and open the template in the editor.

class ProfilesController < ApplicationController
  
  before_filter :init_profile, :action => [:show, :edit, :update, :destroy, :order_cartons]

  def index
    user = User.find_by_id(current_user.id) if current_user
    (user.is? :admin)? @profiles = User.all : @profile = user if user
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

  def edit; end

  def update; end

  def destroy
    unless @profile.is_premium?
      @profile.destroy if @profile.is_destroyable?
      destroy_packages
    else
      # Premium Account erst nach Ablauf der Mitgliedschaft löschen
      # die Kleiderpakete auch erst nach Ablauf der Mitgliedschaft löschen
      if @profile.premium_is_destroyable?
        @profile.destroy 
        destroy_packages
      else
        # ToDo: Speichern des Lösch-Auftrages in einem cronjob, der nach Ende der Mitgliedschaft ausgeführt wird
      end

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

  # Kunden werben Kunden
  # eine Einladungs-E-Mail wird an Freunden gesendet, wie eine Empfehlung
  def invite_friend
    friend = params[:invite_friend]
    profile = User.find_by_id(friend[:user_id])

    UserMailer.send_invitation(friend, profile).deliver
    redirect_to profile_path(profile)
  end

  private

    def init_profile
      init_current_object { @profile = User.find_by_id(params[:id]) }
    end

    def init_current_object
      @current_object = yield
    end

    def destroy_packages
      @profile.packages.each do |package|
        package.destroy if package.is_destroyable?
      end
      UserMailer.cancel_info(@profile).deliver
      redirect_to profiles_path, :notice => I18n.t(:profile_destroyed)
    end
end
