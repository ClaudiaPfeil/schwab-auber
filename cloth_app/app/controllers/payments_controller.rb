# To change this template, choose Tools | Templates
# and open the template in the editor.

class PaymentsController < ApplicationController
  before_filter :init_payment, :action => [:new, :edit, :update, :show, :destroy, :confirm_prepayment]

  def index
    (current_user && !(current_user.is? :admin) ) ? @payments = Payment.where(:user_id => current_user.id) : @payments = Payment.all
  end

  def show

  end

  def new
    @payment = Payment.new()
  end

  def create
    package = Package.find_by_id(params[:payment][:package_id])
    user = package.user
    order = package.order
 
    payment = {:user_id => user.id,
               :order_id => order.id,
               :package_id => package.id,
               :kind  => params[:payment][:kind]
              }
    @payment = Payment.new(payment)
    if @payment.save
      redirect_to profile_path(@payment.user), :notice => I18n.t(:payment_created)
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
end