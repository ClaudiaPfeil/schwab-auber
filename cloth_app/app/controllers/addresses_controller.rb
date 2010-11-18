# To change this template, choose Tools | Templates
# and open the template in the editor.

class AddressesController < ApplicationController
  before_filter :init_address, :action => [:show, :edit, :update, :destroy]

  def index
    current_user.is? :admin ? @addresses = Address.all : @addresses = Address.where(:user_id => current_user.id)
  end

  def show; end

  def new
    @address = Address.new()
  end

  def create
    @address = Address.new(params[:address])
    if @address.save
      redirect_to show_address_path(@address), :notice => I18n.t(:address_created)
    else
      render :action => 'new', :notice => I18n.t(:address_not_created)
    end
  end

  def edit; end

  def update
    if @address.update_attributes(params[:address])
      redirect_to show_address_path(@address), :notice => I18n.t(:address_updated)
    else
      render :action => 'edit', :notice => I18n.t(:address_not_updated)
    end
  end

  def destroy
    @address.destroy if @address.is_destroyable?
    redirect_to addresses_path, :notice => I18n.t(:address_deleted)
  end

  private

    def init_address
      init_current_object { @address = Address.find_by_id_and_user_id(params[:id], current_user.id) }
    end

    def init_current_object
      @current_object = yield
    end
end
