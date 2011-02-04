# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'digest/sha1'


class PaymentsController < ApplicationController
  before_filter :init_payment, :action => [:new, :edit, :update, :show, :destroy, :confirm_prepayment]
   
  PASS_PHRASE = "schwab_und_auber_21"


  def index
    (current_user && !(current_user.is? :admin) ) ? @payments = Payment.order("created_at DESC").where(:user_id => current_user.id, :status => 9) : @payments = Payment.order("created_at DESC").where(:status => 9) if current_user
  end

  def show

  end

  def new
    @payment = Payment.new()
  end

  # Payment-Eintrag wenn:
  # - ein Kleiderpaket bestellt und bezahlt wird mit status=2 oder
  # - ein Upgrade der Premium-Mitgliedschaft erfolgt und diese bezahlt wird mit status=2
  def create
    package = Package.find_by_id(params[:payment][:package_id]) unless params[:payment][:package_id].to_i == 0

    if package
      payment = {:user_id => params[:payment][:user_id],
                 :order_id => package.order.id,
                 :package_id => params[:payment][:package_id],
                 :kind  => params[:payment][:kind],
                 :balance => params[:payment][:balance],
                 :status => 1
                }
    else
      payment = {
                 :user_id => params[:payment][:user_id],
                 :order_id => 0,
                 :package_id => 0,
                 :kind  => params[:payment][:kind],
                 :balance => params[:payment][:balance],
                 :status => 1
                }
    end
    
    @payment = Payment.new(payment)
    if @payment.save
     
      if params[:payment][:kind].to_i == 3
        ogone = prepare_ogone_card(payment)
        ogone['SHASIGN'] = get_sha1(ogone)
         # Bezahlschnittstelle ogone aufrufen, wenn MasterCard/Visa ausgewählt ist
         @ogone = ogone.to_hash
         @notice = I18n.t(:choose_master_visa_card)
        render :action =>  "master_visa_card"
      elsif params[:payment][:kind].to_i == 2
        ogone = prepare_ogone_paypal(payment)
        ogone['SHASIGN'] = get_sha1(ogone)
        # Bezahlschnittstelle ogone aufrufen, wenn Paypal ausgewählt ist
        @ogone = ogone.to_hash
        @notice = I18n.t(:choose_paypal)
        render :action => "paypal"
      elsif params[:payment][:kind].to_i == 4
        ogone = prepare_ogone_direct(payment)
        ogone['SHASIGN'] = get_sha1(ogone)
         # Bezahlschnittstelle ogone aufrufen, wenn Lastschriftverfahren ausgewählt ist
         @ogone = ogone.to_hash
         @notice = I18n.t(:choose_master_visa_card)
        render :action =>  "direct"
      else
        redirect_to profile_path(@payment.user), :notice => I18n.t(:payment_created)
      end
    else
      @payment = @payment
      @notice = I18n.t(:payment_not_created)
      render :action => "new"
    end
  end

  def edit

  end

  def update
    if params[:payment][:email] && params[:payment][:message]
      UserMailer.remember_prepayment(params[:payment], User.find_by_id(params[:payment][:user_id])).deliver
    end
    if @payment.update_attributes(params[:payment])
      redirect_to payments_path, :notice => I18n.t(:payment_updated)
    else
      #@payment = @payment
      @notice = I18n.t(:payment_not_updated)
      render :action => "edit"
    end
  end

  def destroy
    @payment.destroy if @payment.is_destroyable?
    redirect_to payments_path, :notice => I18n.t(:payment_destroyed)
  end

  def confirm_prepayment
    if @payment.update_attribute(:prepayment_confirmed, true)
      redirect_to payments_path, :notice => I18n.t(:prepayment_confirmed)
    else
      @payment = @payment
      @notice = I18n.t(:prepayment_not_confirmed)
      render :action => "index"
    end
  end

  def all_unconfirmed
    @payments = Payment.where(:prepayment_confirmed => false).joins("INNER JOIN users on users.id = payments.user_id and users.membership = 1")
  end

  def master_visa_card
    
  end

  def paypal
    
  end

  def accept
    order_id, status, pay_id, nc_error, trx_date, shasign = prepare_feedback(params)
    @payment = Payment.find_by_order_id(order_id)
    if @payment
      @payment.update_attributes(:status => status, :pay_id => pay_id, :nc_error => nc_error)
      if status.to_i == 9
        # order aktualisieren, setzen des status=2 für paied
        # package aktualisieren, setzen des status=2 für paied
        @payment.order.update_attribute(:status, 2)
        @payment.package.update_attribute(:state, 2)
        # inform creator of the package to send it if payed
        user = User.find_by_id(@payment.package.user_id)
        receiver =  User.find_by_id(@payment.user_id)
        package = Package.find_by_id(@payment.package_id)
        coupon = Coupon.where(:used => 0)
        coupon.update_attribute(:used, 1)
        UserMailer.send_package_ordered_email(user, receiver, package, coupon.code).deliver if user && receiver && package
      else
        # order zurücksetzen (stornieren)
        # package wieder freigeben
        @payment.order.update_attribute(:status, 0)
        @payment.package.update_attribute(:state, 0)
      end
    end
  end

  def decline
    order_id, status, pay_id, nc_error, trx_date, shasign = prepare_feedback(params)
    @payment = Payment.find_by_order_id(order_id)
    if @payment
      @payment.update_attributes(:status => status, :pay_id => pay_id, :nc_error => nc_error)
      # order zurücksetzen (stornieren)
      # package wieder freigeben
      @payment.order.update_attribute(:status, 0)
      @payment.package.update_attribute(:state, 0)
    end
  end

  def exception
    order_id, status, pay_id, nc_error, trx_date, shasign = prepare_feedback(params)
    @payment = Payment.find_by_order_id(order_id)
    if @payment
      @payment.update_attributes(:status => status, :pay_id => pay_id, :nc_error => nc_error)
      # order zurücksetzen (stornieren)
      # package wieder freigeben
      @payment.order.update_attribute(:status, 0)
      @payment.package.update_attribute(:state, 0)
    end
  end

  def cancel
    order_id, status, pay_id, nc_error, trx_date, shasign = prepare_feedback(params)
    @payment = Payment.find_by_order_id(order_id)
    if @payment
      @payment.update_attributes(:status => status, :pay_id => pay_id, :nc_error => nc_error)
      # order zurücksetzen (stornieren)
      # package wieder freigeben
      @payment.order.update_attribute(:status, 0)
      @payment.package.update_attribute(:state, 0)
    end
  end

  private

    def init_payment
      init_current_object { @payment = Payment.find_by_id(params[:id])}
    end

    def init_current_object
      @current_object = yield
    end

    def prepare_ogone_card(params) 
      ogone = {   'ACCEPTURL' => Payment::ACCEPT_URL,
                  'AMOUNT'  => params[:balance],
                  'BGCOLOR' => Payment::BGCOLOR,
                  'BRAND' => Payment::BRAND,
                  'BUTTONBGCOLOR' => Payment::BUTTONBGCOLOR,
                  'BUTTONTXTCOLOR' => Payment::BUTTONTXTCOLOR,
                  'CANCELURL' => Payment::CANCEL_URL,
                  'CATALOGURL' => Payment::CATALOG_URL,
                  'COMPLUS' => params[:order_id],
                  'CURRENCY' => Payment::CURRENCY,
                  'DECLINEURL' => Payment::DECLINE_URL,
                  'EMAIL' => User.find_by_id(params[:user_id]).email,
                  'EXCEPTIONURL' => Payment::EXCEPTION_URL,
                  'FONTTYPE' => Payment::FONTTYPE,
                  'HOMEURL' => Payment::HOME_URL,
                  'LANGUAGE' => Payment::LANGUAGE,
                  'LOGO' => Payment::LOGO,
                  'OPERATION' => Payment::OPERATION,
                  'ORDERID' => params[:order_id],
                  'PARAMPLUS' => "id=#{params[:user_id]}",
                  'PM' => Payment::PM_CARD,
                  'PMLIST' => Payment::PMLIST,
                  'PMLISTTYPE' => Payment::PMLISTTYPE,
                  'PSPID' => Payment::PSPID,
                  'TBLBGCOLOR' => Payment::TBLBGCOLOR,
                  'TITLE' => Payment::TITLE,
                  'TXTCOLOR' => Payment::TXTCOLOR,
                  'USERID' => params[:user_id],
                  'WIN3DS' => Payment::WIN3DS      
                  }
    end

    def prepare_ogone_paypal(params)
      ogone = { 'AMOUNT'  => params[:balance],
                'BGCOLOR' => Payment::BGCOLOR,
                'BRAND' => Payment::BRAND_PAYPAL,
                'BUTTONBGCOLOR' => Payment::BUTTONBGCOLOR,
                'BUTTONTXTCOLOR' => Payment::BUTTONTXTCOLOR,
                'CURRENCY' => Payment::CURRENCY,
                'FONTTYPE' => Payment::FONTTYPE,
                'LANGUAGE' => Payment::LANGUAGE,
                'ORDERID' => params[:order_id],
                'PM' => Payment::PM,
                'PSPID' => Payment::PSPID,
                'TBLBGCOLOR' => Payment::TBLBGCOLOR,
                'TITLE' => Payment::TITLE,
                'TXTCOLOR' => Payment::TXTCOLOR
              }
    end

    def prepare_ogone_direct(params)
      ogone = { 'AMOUNT'  => params[:balance],
                'BGCOLOR' => Payment::BGCOLOR,
                'BRAND' => Payment::BRAND_DIRECT,
                'BUTTONBGCOLOR' => Payment::BUTTONBGCOLOR,
                'BUTTONTXTCOLOR' => Payment::BUTTONTXTCOLOR,
                'CURRENCY' => Payment::CURRENCY,
                'FONTTYPE' => Payment::FONTTYPE,
                'LANGUAGE' => Payment::LANGUAGE,
                'ORDERID' => params[:order_id],
                'PM' => Payment::PM_DIRECT,
                'PSPID' => Payment::PSPID,
                'TBLBGCOLOR' => Payment::TBLBGCOLOR,
                'TITLE' => Payment::TITLE,
                'TXTCOLOR' => Payment::TXTCOLOR
              }
    end

    def get_sha1(payment)
      sha1_key = ''
      payment.sort.each { |key, value| sha1_key << key.to_s + "=" + value.to_s + PASS_PHRASE}
      puts "SHA1-Key= " + sha1_key
      puts (Digest::SHA1.hexdigest(sha1_key).to_s.upcase)
      Digest::SHA1.hexdigest(sha1_key).to_s.upcase
    end

    def prepare_feedback(params)
      if params
        order_id = params[:ORDER_ID]
        status   = params[:STATUS]
        pay_id   = params[:PAYID]
        nc_error = params[:NCERROR]
        trx_date = params[:TRXDATE]
        shasign  = params[:SHASIGN]
        
        return order_id, status, pay_id, nc_error, trx_date, shasign
      end
    end
end
