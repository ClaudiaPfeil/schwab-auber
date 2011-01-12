# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'digest/sha1'


class PaymentsController < ApplicationController
  before_filter :init_payment, :action => [:new, :edit, :update, :show, :destroy, :confirm_prepayment]
   
  PASS_PHRASE = "schwab_und_auber_21"


  def index
    (current_user && !(current_user.is? :admin) ) ? @payments = Payment.order("created_at DESC").where(:user_id => current_user.id) : @payments = Payment.order("created_at DESC").all
  end

  def show

  end

  def new
    @payment = Payment.new()
  end

  # Payment-Eintrag wenn:
  # - ein Kleiderpaket bestellt wird oder
  # - ein Upgrade der Premium-Mitgliedschaft erfolgt
  def create
    package = Package.find_by_id(params[:payment][:package_id]) unless params[:payment][:package_id].to_i == 0

    if package
      payment = {:user_id => params[:payment][:user_id],
                 :order_id => package.order.id,
                 :package_id => params[:payment][:package_id],
                 :kind  => params[:payment][:kind],
                 :balance => params[:payment][:balance]
                }
    else
      payment = {
                 :user_id => params[:payment][:user_id],
                 :order_id => 0,
                 :package_id => 0,
                 :kind  => params[:payment][:kind],
                 :balance => params[:payment][:balance]
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
                  'ORDERID' => params[:order_id],
                  'OPERATION' => Payment::OPERATION,
                  'PARAMPLUS' => "id=#{params[:user_id]}",
                  'PM' => Payment::PM_CARD,
                  'PMLIST' => Payment::PMLIST,
                  'PMLISTTYPE' => Payment::PMLISTTYPE,
                  'PSPID' => Payment::PSPID,
                  'TP' => Payment::TP,
                  'TBLBGCOLOR' => Payment::TBLBGCOLOR,
                  'TITLE' => Payment::TITLE,
                  'TXTCOLOR' => Payment::TXTCOLOR,
                  'USERID' => params[:user_id],
                  'WIN3DS' => Payment::WIN3DS      
                  }
    end

    def prepare_ogone_paypal(params)
      ogone = { 'ACCEPTURL' => Payment::ACCEPT_URL,
                'AMOUNT'  => params[:balance],
                'BGCOLOR' => Payment::BGCOLOR,
                'BUTTONBGCOLOR' => Payment::BUTTONBGCOLOR,
                'BUTTONTXTCOLOR' => Payment::BUTTONTXTCOLOR,
                'COMPLUS' => params[:order_id],
                'CANCELURL' => Payment::CANCEL_URL,
                'CATALOGURL' => Payment::CATALOG_URL,
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
                'PSPID' => Payment::PSPID,
                'TBLBGCOLOR' => Payment::TBLBGCOLOR,
                'TITLE' => Payment::TITLE,
                'TP' => Payment::TP,
                'TXTCOLOR' => Payment::TXTCOLOR,
                'TXTOKEN' => Payment::TXTOKEN,
                'USERID' => params[:user_id],
                'WIN3DS' => Payment::WIN3DS
              }
    end

    def get_sha1(payment)
      sha1_key = ''
      payment.sort.each { |key, value| sha1_key << key.to_s + "=" + value.to_s + PASS_PHRASE}
      puts "SHA1-Key= " + sha1_key
      Digest::SHA1.hexdigest(sha1_key)
    end

end
