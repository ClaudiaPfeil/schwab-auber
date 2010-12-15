class UsersController < ApplicationController
  # Protect these actions behind an admin login
  # before_filter :admin_required, :only => [:suspend, :unsuspend, :destroy, :purge]
  before_filter :find_user, :only => [:suspend, :unsuspend, :destroy, :purge, :update, :invite_friend, :confirm_delivery]

  # render new.rhtml
  def new
    @user = User.new
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    @user.register! if @user && @user.valid?
    success = @user && @user.valid?
    if success && @user.errors.empty?
      # Prüfen, ob Neukunde ein geworbener Kunde ist?
      if cookies[:invited]
        create_lead(@user)
        set_premium_first_month(@user)
      end
      redirect_back_or_default('/', :notice => "Thanks for signing up!  We're sending you an email with your activation code.")
    else
      flash.now[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end

  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      redirect_to '/login', :notice => "Signup complete! Please sign in to continue."
    when params[:activation_code].blank?
      redirect_back_or_default('/', :flash => { :error => "The activation code was missing.  Please follow the URL from your email." })
    else 
      redirect_back_or_default('/', :flash => { :error  => "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in." })
    end
  end

  def suspend
    @user.suspend! 
    redirect_to users_path
  end

  def unsuspend
    @user.unsuspend! 
    redirect_to users_path
  end

  def destroy
    @user.delete!
    redirect_to profiles_path
  end

  def purge
    @user.destroy
    redirect_to users_path
  end

  # Aktualisieren des Nutzer-Profils wie Passwort, Name, E-Mail usw.
  def update
    user = params[:user]
    if user[:membership] == true
      user[:role] << "premium"
      period = 0
      if user[:premium_period] == 0
        period = 3.months.from_now
      elsif user[:premium_period] == 1
        period = 6.months.from_now
      elsif user[:premium_period] == 2
        period = 1.years.from_now
      end
      user[:membership_ends] = period
    end

    if @user.update_attributes(user)
      if @user.option.nil? && !user[:option].nil?
        option = params[:option]
        option[:user_id] = params[:id].to_i
        Option.create(option)
      end
      redirect_to profiles_path, :notice => I18n.t(:profile_updated)
    else
      render :action => 'edit', :notice => I18n.t(:profile_not_updated)
    end
  end

  # Suche nach Nutzerprofilen z.B. nach Bewertungen oder eingestellten Paketen
  def search
    search_type, search_key = params[:search_type], params[:search_key]
    @profiles = User.search_by_attributes(search_key, search_type) unless search_type.nil? || search_key.nil?
  end

  def confirm_delivery
    @user.update_attribute(:confirmed_delivery, 1)
    redirect_to dashboard_path
  end
  
  # There's no page here to update or destroy a user.  If you add those, be
  # smart -- make sure you check that the visitor is authorized to do so, that they
  # supply their old password along with a new one to update it, etc.

  protected

  def find_user
    @user = User.find(params[:id])
  end

  def create_lead(user)
    lead = {  :cookie_key => cookies[:invited].split("cookie_key").second.split("remote_ip").first,
              :new_user_id => user.id,
              :user_id => cookies[:invited].split("user_id").second.split("cookie_key").first,
              :remote_ip => cookies[:invited].split("remote_ip").second.split("clicker_key").first
    }
    
    Lead.create(lead)
  end

  def set_premium_first_month(user)
    user.update_attributes(:membership => 1, :membership_starts => Date.today, :membership_ends => 1.months.from_now)
  end

end
