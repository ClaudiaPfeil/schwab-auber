class OrdersController < ApplicationController
  include Cms

  before_filter :init_order, :actions => [:show, :edit, :update, :destroy, :show_bill]

  def index
    if current_user.is? :admin
      @orders = Order.all
      @orders = @orders.to_a unless @orders.nil?
    else
      @orders = Order.where(:user_id => current_user.id) if current_user
      @orders = @orders.to_a unless @orders.nil?
    end
    
  end

  def show; end

  def new
    @order = Order.new()
  end

  def create
    @order = Order.new()

    package = Package.find_by_id(params[:id])
    @order.package_number = package.serial_number
    @order.package_id = package.id
    @order.user_id = current_user.id

    if @order.check_change_principle == true && @order.check_holidays == true
    
      if @order.save
        redirect_to order_path(@order), :notice => I18n.t(:order_created)
      else
        @order = @order
        @notice = I18n.t(:order_not_created)
        render :action => 'new'
      end
    else
      @order = @order
      @notice = I18n.t(:equal_change_principle)
      render :action => 'new'
    end
    
  end

  def edit; end

  def update
    if @order.update_attributes(params[:order])
      if (current_user.is? :admin)
        redirect_to orders_path, :notice => I18n.t(:order_updated)
      else
        redirect_to profile_path(@order.user), :notice => I18n.t(:order_not_updated)
      end
    else
      @order = @order
      @notice = I18n.t(:order_not_updated)
      render :action => 'edit'
    end
  end

  def destroy
    @order.destroy if @order.is_destroyable?
    @order.package.update_attribute(:state, 0)
    redirect_to orders_path, :notice => I18n.t(:order_deleted)
  end

  def search
    search_type, search_key = params[:search_type], params[:search_key]
    @packages = Package.search_by_attributes(search_key, search_type) unless search_type.nil? || search_key.nil?
  end

  private

    def init_order
      if current_user.is? :admin
        init_current_object { @order = Order.find_by_id(params[:id]) } unless current_user.nil?
      else
        init_current_object { @order = Order.find_by_id_and_user_id(params[:id], current_user.id)} unless current_user.nil?
      end
    end

    def init_current_object
      @current_object = yield
    end
end
