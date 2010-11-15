class PackagesController < ApplicationController
  include Cms
  
  before_filter :init_package, :action => [:show, :edit, :update, :destroy, :order]
  before_filter :init_content, :action => [:index, :show, :edit, :update, :order]

  def index
    @packages = Package.where(:user_id => current_user.id) if current_user
    @packages = @packages.to_a unless @packages.nil?
  end

  def show
    
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
      if search_key == 'Junge'
        search_key = 0
      elsif search_key == 'Mädchen'
        search_key = 1
      end
    end
    @packages = Package.search_by_attributes(search_key, search_type) unless search_type.nil? || search_key.nil?
  end

  def order
    #create order
    order = Order.new()
    package = Package.find_by_id(params[:id])
    order.package_number = package.serial_number
    order.package_id = package.id
    order.user_id = current_user.id
    
    if order.check_change_principle == true
      if order.save
        render :action => 'search', :notice => :order_created
      else
        render :action => 'search', :notice => :order_not_created
      end
    else
      render :action => 'new', :notice => I18n.t(:equal_change_principle)
    end
    
  end

  private

    def init_package
      init_current_object { @package = Package.find_by_id_and_user_id(params[:id], current_user.id)} unless current_user.nil?
    end

    def init_content
      init_current_object { @contents = get_content("Packages")}
    end

    def init_current_object
      @current_object = yield
    end
    
end
