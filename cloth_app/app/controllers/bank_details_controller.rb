# To change this template, choose Tools | Templates
# and open the template in the editor.

class BankDetailsController < ApplicationController
  before_filter :init_bank_detail, :action => [:edit, :update, :show, :destroy]

  def index
    (current_user.is? :admin) ? @bank_details  = BankDetail.all : @bank_details = BankDetail.all.where(:user_id => params[:user_id])
  end

  def show

  end

  def new
    @bank_detail  = BankDetail.new()
  end

  def create
    @bank_detail  = BankDetail.new(params[:bank_detail])
    if @bank_detail.save
      redirect_to bank_details_path, :notice  => I18n.t(:bank_detail_created)
    else
      render  :action => 'new', :notice => I18n.t(:bank_detail_created_failed)
    end
  end

  def edit

  end

  def update
    if @bank_detail.update_attributes(params[:bank_detail])
      redirect_to bank_details_path, :notice  =>  I18n.t(:bank_detail_updated)
    else
      render  :action => 'edit', :notice  =>  I18n.t(:bank_detail_updated_failed)
    end
  end

  def destroy
    @bank_detail.destroy if @bank_detail.is_destroyable?
    redirect_to bank_details_path, :notice  => I18n.t(:bank_detail_deleted)
  end

  def payment_method
    package = Package.find_by_id(params[:id])
    @bank_detail = BankDetail.new(params[:bank_detail])

    if @bank_detail.save
      redirect_to profile_path(package.order.user), :notice => I18n.t(:payment_created)
    end
    
  end

  private
    def init_bank_detail
      init_current_object { @bank_detail  = BankDetail.find_by_id(params[:id])}
    end

    def init_current_object
      @current_object = yield
    end
end
