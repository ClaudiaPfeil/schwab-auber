# To change this template, choose Tools | Templates
# and open the template in the editor.
require "uri"
require "net/http"

class PaymentsController < ApplicationController
  before_filter :init_payment, :action => [:new, :edit, :update, :show, :destroy, :confirm_prepayment]

  SHA_SIGNATUR = "B7DB33CA21A704FF97ECA72608491AF739DDFE4952932A9AAEE6B1806764D9469FE0980369693A7B65341A08EF9B8B037E482663951CD9608CC3536D4079EB26"
  PASS_PHRASE = "schwab_und_auber_21"


  def index
    (current_user && !(current_user.is? :admin) ) ? @payments = Payment.where(:user_id => current_user.id) : @payments = Payment.all
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
    unless params[:payment][:package_id].blank?
      package = Package.find_by_id(params[:payment][:package_id])
      user = package.user
      order = package.order

      payment = {:user_id => user.id,
                 :order_id => order.id,
                 :package_id => package.id,
                 :kind  => params[:payment][:kind],
                 :balance => params[:payment][:AMOUNT]
                }
    else
      payment = {
                 :user_id => user.id,
                 :order_id => 0,
                 :package_id => 0,
                 :kind  => params[:payment][:kind],
                 :balance => params[:payment][:AMOUNT]
                }
    end
    
    @payment = Payment.new(payment)
    if @payment.save
      # Bezahlschnittstelle ogone aufrufen, wenn MasterCard/Visa ausgewählt ist
      if params[:payment][:kind].to_i == 3 
        send_to_ogone(params[:payment])
      # Bezahlschnittstelle ogone aufrufen, wenn Paypal ausgewählt ist
      elsif params[:payment][:kind].to_i == 2
        send_to_ogone_paypal(params[:payment])
      else
        redirect_to profile_path(@payment.user), :notice => I18n.t(:payment_created)
      end
    else
      render :action => "new", :notice => I18n.t(:payment_not_created)
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
      render :action => "edit", :notice => I18n.t(:payment_not_updated)
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
      render :action => "index", :notice => I18n.t(:prepayment_not_confirmed)
    end
  end

  def all_unconfirmed
    @payments = Payment.where(:prepayment_confirmed => false).joins("INNER JOIN users on users.id = payments.user_id and users.membership = 1")
  end

  private

    def init_payment
      init_current_object { @payment = Payment.find_by_id(params[:id])}
    end

    def init_current_object
      @current_object = yield
    end

    def send_to_ogone(params)
      url = "https://secure.ogone.com/ncol/test/orderstandard.asp"
      infos = { 'PSPID'   => params[:PSPID].to_s,
                'ORDERID' => params[:ORDERID].to_s,
                'AMOUNT'  => params[:AMOUNT].to_s,
                'CURRENCY' => params[:CURRENCY].to_s,
                'LANGUAGE' => params[:LANGUAGE].to_s,
                'EMAIL' => params[:EMAIL].to_s,
                'SHASIGN' => SHA_SIGNATUR.to_s,
                'TITLE' => params[:TITLE].to_s,
                'BGCOLOR' => params[:BGCOLOR].to_s,
                'TXTCOLOR' => params[:TXTCOLOR].to_s,
                'TBLBGCOLOR' => params[:TBLBGCOLOR].to_s,
                'TBLTXTCOLOR' => params[:TBLTXTCOLOR].to_s,
                'BUTTONBGCOLOR' => params[:BUTTONBGCOLOR].to_s,
                'BUTTONTXTCOLOR' => params[:BUTTONTXTCOLOR].to_s,
                'LOGO' => params[:LOGO].to_s,
                'FONTTYPE' => params[:FONTTYPE].to_s,
                'TP' => params[:TP].to_s,
                'PM' => params[:PM].to_s,
                'BRAND' => params[:BRAND].to_s,
                'WIN3DS' => params[:WIN3DS].to_s,
                'PMLIST' => params[:PMLIST].to_s,
                'PMLISTTYPE' => params[:PMLISTTYPE].to_s,
                'HOMEURL' => params[:HOMEURL].to_s,
                'CATALOGURL' => params[:CATALOGURL].to_s,
                'COMPLUS' => params[:COMPLUS].to_s,
                'PARAMPLUS' => params[:PARAMPLUS].to_s,
                'ACCEPTURL' => params[:ACCEPTURL].to_s,
                'DECLINEURL' => params[:DECLINEURL].to_s,
                'EXCEPTIONURL' => params[:EXCEPTIONURL].to_s,
                'CANCELURL' => params[:CANCELURL].to_s,
                'OPERATION' => params[:OPERATION].to_s,
                'USERID' => params[:USERID].to_s
              }
              
          x = Net::HTTP.post_form(URI.parse(url), infos)
          puts "send_to_ogone: " + x.body
      end

      def send_to_ogone_paypal(params)
        url = "https://secure.ogone.com/ncol/test/orderstandard.asp"
        infos = { "PSPID" => params[:PSPID].to_s,
                  "ORDERID" => params[:ORDERID].to_s,
                  "AMOUNT" => params[:AMOUNT].to_s,
                  "CURRENCY" => params[:CURRENCY].to_s,
                  "LANGUAGE" => params[:LANGUAGE].to_s,
                  "ACCEPTURL" => params[:ACCEPTURL].to_s,
                  "DECLINEURL" => params[:DECLINEURL].to_s,
                  "PM" => params[:PM].to_s,
                  "TXTOKEN" => params[:TXTOKEN].to_s,
                  "TITLE" => params[:TITLE].to_s,
                  "BGCOLOR" => params[:BGCOLOR].to_s,
                  "TXTCOLOR" => params[:TXTCOLOR].to_s,
                  "TBLBGCOLOR" => params[:TBLBGCOLOR].to_s,
                  "TBLTXTCOLOR" => params[:TBLTXTCOLOR].to_s,
                  "BUTTONBGCOLOR" => params[:BUTTONBGCOLOR].to_s,
                  "BUTTONTXTCOLOR" => params[:BUTTONTXTCOLOR].to_s,
                  "LOGO" => params[:LOGO].to_s,
                  "FONTTYPE" => params[:FONTTYPE].to_s
                }

        x = Net::HTTP.post_form(URI.parse(url), infos)
        puts "send_to_ogone_paypal: " + x.body
      end

end
