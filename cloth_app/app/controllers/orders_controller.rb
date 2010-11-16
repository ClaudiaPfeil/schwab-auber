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
    @order = Order.new(params[:order])

    package = Package.find_by_id(params[:order][:package_id])
    @order.package_number = package.serial_number unless package.serial_number.nil?
    
    if @order.check_change_principle == true
      if @order.save
        redirect_to order_path(@order), :notice => I18n.t(:order_created)
      else
        render :action => 'new', :notice => I18n.t(:order_not_created)
      end
    else
      render :action => 'new', :notice => I18n.t(:equal_change_principle)
    end
    
  end

  def edit; end

  def update
    if @order.update_attributes(params[:order])
      redirect_to orders_path, :notice => :order_updated#'Order successfully updated'
    else
      render :action => 'edit'
    end
  end

  def destroy
    @order.destroy if @order.is_destroyable?
    @order.package.update_attribute(:state, 0)
    redirect_to orders_path, :notice => :order_deleted#'Order successfully deleted'
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
