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
    # prüfen, ob Kunde bereits eine Liefer- und Rechnungsanschrift besitzt und
    # prüfen, das jeweils nur eine Adresse hinzugefügt werden darf
    if check_address(@address.kind)

      if @address.save
        profile = User.find_by_id(@address.user_id)
        redirect_to edit_profile_path(profile), :notice => I18n.t(:address_created)
      else
        @address = @address
        @notice = I18n.t(:address_not_created)
        render :action => 'new'
      end

    else
      @address = @address
      @notice  = I18n.t(:address_not_unique)
      render :action => 'new'
    end
    
  end

  def edit; end

  def update
    # alles außer die Art der Anschrift aktualisieren
    params[:address].delete("kind")
    if @address.update_attributes(params[:address])
      redirect_to address_path(@address), :notice => I18n.t(:address_updated)
    else
      @address = @address
      @notice = I18n.t(:address_not_updated)
      render :action => 'edit'
    end
  end

  def destroy
    @address.destroy if @address.is_destroyable?
    profile = User.find_by_id(@address.user_id)
    redirect_to edit_profile_path(profile), :notice => I18n.t(:address_deleted)
  end

  private

    def init_address
      init_current_object { @address = Address.find_by_id(params[:id]) }
    end

    def init_current_object
      @current_object = yield
    end

    def check_address(kind)
      user = User.find_by_id(@address.user_id)
      #user.has_delivery_address? && user.has_bill_address? ? false : true
      if user.has_delivery_address?
        kind == 0 ? false : true
      elsif user.has_bill_address?
        kind == 1 ? false : true
      elsif user.has_delivery_address? && user.has_bill_address?
        false
      else
        true
      end
    end
end
