class PackagesController < ApplicationController
  before_filter :init_package, :action => [:show, :edit, :update, :destroy, :order]

  def index
    @packages = Package.where(:user_id => current_user.id) if current_user
    @packages = @packages.to_a unless @packages.nil?
  end

  def show
    
  end
  
  # Anzeige aller Pakete, die in den vergangenen 24 Stunden eingestellt wurden
  def show_24
    @packages = Package.where(:created_at => "BETWEEN #{Date.today} AND DATE_SUB(#{Date.today}, #{Date.today - 24.hours}) ")
  end

  def new
    @package = Package.new()
  end

  def create
    @package = Package.new(params[:package])

    if @package.save
      redirect_to packages_path(@package), :notice => :package_created
    else
      render :action => 'new', :notice => :package_not_created
    end
    
  end

  def edit; end

  def update
    if @package.update_attributes(params[:package])
      redirect_to packages_path(@package), :notice => :package_updated
    else
      render :action => 'edit', :notice => :package_not_updated#
    end
  end

  def destroy
    @package.destroy if @package.destroyable?
    redirect_to packages_path
  end

  def search
    search_type, search_key = params[:search_type], params[:search_key]
    if search_type == 'sex'
      if search_key =~ /^(j|J)(u|U)(n|N)(g|G)/
        search_key = 0
      elsif search_key =~ /^(m|M)(a|A)(e|E)(d|D)(c|C)(h|H)(e|E)(n|N)/
        search_key = 1
      end
    end
    @packages = Package.search_by_attributes(search_key, search_type) unless search_type.nil? || search_key.nil?
  end

  def order
    #create order
    @order = Order.new(:package_number => @package.serial_number,
                      :package_id     => @package.id,
                      :user_id        => current_user.id
                    )

    @order.bill_number = @order.get_bill_number
    @order.order_number  = @order.get_order_number
    @order.package.accepted = 1
    @order.package.confirmed = 1

    if @order.check_change_principle == true && @order.check_holidays == true
      
      if @order.save
        # count down cartons
        @package.user.count_down
        redirect_to payment_method_bank_detail_path(@package), :notice => :order_created
      else
        render :action => 'search', :notice => :order_not_created
      end
    else
      render :action => 'search', :notice => I18n.t(:check_failed)
    end
  
  end

  private

    def init_package
      init_current_object { @package = Package.find_by_id_and_user_id(params[:id], current_user.id)} unless current_user.nil?
    end

    def init_current_object
      @current_object = yield
    end
    
end
