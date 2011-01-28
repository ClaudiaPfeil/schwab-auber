class UsersController < ApplicationController
  # Protect these actions behind an admin login
  # before_filter :admin_required, :only => [:suspend, :unsuspend, :destroy, :purge]
  before_filter :find_user, :only => [:suspend, :unsuspend, :destroy, :purge, :update, :invite_friend, :confirm_delivery, :reset_password]

  # render new.rhtml
  def new
    @user = User.new if @user.nil?
  end
 
  def create
    logout_keeping_session!
    address = Address.new(params[:user][:address])

    if address  
      @user = User.new(params[:user])
      @user.register! if @user && @user.valid?

      success = @user && @user.valid?
      if success && @user.errors.empty?
        address.receiver = params[:user][:first_name] + " " + params[:user][:last_name]
        address.user_id = @user.id
        if address.valid? && address.save!
          # Prüfen, ob Neukunde ein geworbener Kunde ist?
          if cookies[:invited]
            create_lead(@user)
            set_premium_first_month(@user)
            #delete cookie
            cookies.delete :invited
          end
          redirect_back_or_default('/', :notice => I18n.t(:user_created) )
        else
          @user = User.new(params[:user])
          flash.now[:error]  = I18n.t(:address_not_created)
          render :action => 'new'
        end
      else
        @user = User.new(params[:user])
        flash.now[:error]  = I18n.t(:user_not_created)
        render :action => 'new'
      end
    else
      @user = User.new(params[:user])
      flash.now[:error]  = I18n.t(:address_missing)
      render :action => 'new'
    end
    
  end

  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      redirect_to '/login', :notice => "Registrierung vollständig! Bitte melden sie sich an, um fortzufahren."
    when params[:activation_code].blank?
      redirect_back_or_default('/', :flash => { :error => "Der Aktivierungscode fehlt.  Folgen sie bitte dem Link ihrer E-Mail." })
    else 
      redirect_back_or_default('/', :flash => { :error  => "Wir konnten keinen Nutzer mit diesem Aktivierungscode finden -- kontrollieren sie ihre E-Mail? Oder ihr Nutzerkonto wurde bereits aktiviert -- Versuchen sie sich anzumelden." })
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
    
    if user[:membership] == "true"
      user[:role] = "premium"
      period = ''
      if user[:premium_period] == 0
        period = 3.months.from_now.to_s
      elsif user[:premium_period] == 1
        period = 6.months.from_now.to_s
      elsif user[:premium_period] == 2
          period = 1.years.from_now.to_s
      end
      user[:membership_ends] = period
    end
    
    if @user.update_attributes(user)
      
      if @user.option.nil? && !params[:option].nil?
        option = params[:option]
        option[:user_id] = params[:id].to_i
        Option.create(option)
      end
      
      if user[:membership] == "true"
        
        if @user.update_attributes({:role => "premium", :premium_period => user[:premium_period], :membership_ends => period, :membership_starts => Date.today, :membership => true} )
          redirect_to payment_method_bank_detail_path(@user, :upgrade => true), :notice => I18n.t(:membership_upgraded)
        else
          @user = @user
          @notice = I18n.t(:membership_not_upgraded)
          render :action => 'edit'
        end
      else
        redirect_to profiles_path, :notice => I18n.t(:profile_updated)
      end
      
    else
      @user = @user
      @notice = I18n.t(:profile_not_updated)
      render :action => 'edit'
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

  def forgot_password
    user = User.find_by_login_and_email(params[:forgot_password][:login], params[:forgot_password][:email])
    notice = ''
    if user
      UserMailer.forgot_password(user).deliver
      notice += I18n.t(:send_link)
    else
      notice += "Kein Nutzerkonto zu Login = #{params[:forgot_password][:login]} und E-Mail = #{params[:forgot_password][:email]} gefunden!"
    end
    redirect_back_or_default('/', :notice => notice )
  end

  def reset_password
    if params[:user]
      if @user.update_attribute(:password, params[:user][:password])
        redirect_to login_path, :notice => I18n.t(:password_reseted_successfully)
      end
    end
    
  end
  # There's no page here to update or destroy a user.  If you add those, be
  # smart -- make sure you check that the visitor is authorized to do so, that they
  # supply their old password along with a new one to update it, etc.

  protected

  def find_user
    @user = User.find_by_id(params[:id])
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
    user.update_attributes(:membership => 1, :membership_starts => Date.today, :membership_ends => Date.today + 1.months)
  end

end
