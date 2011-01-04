class PackagesController < ApplicationController
  before_filter :init_package, :action => [:show, :edit, :update, :destroy]
  before_filter :init_order_package, :action => [:order]

  # Alle Kunden dürfen alle Kleiderpakete sehen, egal ob Basis, Premium oder Gast
  def index
    @packages = Package.all 
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
    @package = Package.new(prepare_package(params[:package]))
    
    if @package.save
      redirect_to packages_path(@package), :notice => I18n.t(:package_created)
    else
      render :action => 'new', :notice => I18n.t(:package_not_created)
    end
    
  end

  def edit; end

  def update
    if @package.update_attributes(prepare_package(params[:package]))
      redirect_to packages_path(@package), :notice => I18n.t(:package_updated)
    else
      render :action => 'edit', :notice => I18n.t(:package_not_updated)
    end
  end

  def destroy
    @package.destroy if @package.destroyable?
    redirect_to packages_path
  end

  def search
    #search_type, search_key = params[:search_type], params[:search_key]
    search_type = params[:search_type].split(" ")
    search_key = params[:search_key].split(" ")
    
    if search_type.first.count > 1 && search_key.count  > 1
      search_key.each_with_index do |key, i|
        key = transform_param(key) if search_type.first[i] == 'sex'
        i == 0 ? @packages = Package.search_by_attributes(key, search_type.first[i]) : @packages = @packages.search_by_attributes(key, search_type.first[i])
      end
    else   
      search_key = transform_param(search_key.to_s) if search_type.to_s == 'sex'
      @packages = Package.search_by_attributes(search_key, search_type) unless search_type.nil? || search_key.nil?
    end
    @packages
  end

  def order
    #create order
    @order = Order.new(:package_number => @package.serial_number,
                       :package_id     => @package.id,
                       :user_id        => current_user.id
                      )
  
    @order.package.accepted = 1
    @order.package.confirmed = 1
    @order.package.user.accepted = 1
    
    if @order.check_change_principle == true && @order.check_holidays == true
      @order.order_number  = @order.get_order_number
      @order.bill_number = @order.get_bill_number
      if @order.save!
        # count down cartons
        @package.user.count_down
        redirect_to payment_method_bank_detail_path(@package), :notice => I18n.t(:order_created)
      else
        @packages = Package.all
        @notice = I18n.t(:order_not_created)
        render :action => 'index'
      end
    else
      @packages = Package.all
      @notice = I18n.t(:check_failed)
      render :action => 'index'
    end
  
  end

  private

    def init_package
      init_current_object { (current_user.is? :admin)? @package = Package.find_by_id(params[:id]) : @package = Package.find_by_id_and_user_id(params[:id], current_user.id)} unless current_user.nil?
    end

    def init_order_package
      init_current_object { @package = Package.find_by_id(params[:id])}
    end

    def init_current_object
      @current_object = yield
    end

    def prepare_package(package)
      result = { }
      result[:serial_number] = package[:serial_number]
      result[:sex] = package[:sex]
      result[:notice] = package[:notice]
      result[:size] = package[:size]
      result[:next_size] = package[:next_size]
      result[:amount_clothes] = package[:amount_clothes]
      result[:age] = package[:age]
      result[:amount_labels] = package[:amount_labels]
      result[:confirmed] = package[:confirmed]
      result[:accepted] = package[:accepted]
      !package[:kind].nil? ? result[:kind] = package[:kind].collect{ |k| k + "," }.to_s : package[:kind]
      !package[:shirts].nil? ? result[:shirts] = package[:shirts].collect{ |k| k + "," }.to_s : package[:shirts]
      !package[:blouses].nil? ? result[:blouses] = package[:blouses].collect{ |k| k + "," }.to_s : package[:blouses]
      !package[:jeans].nil? ? result[:jeans] = package[:jeans].collect{ |k| k + "," }.to_s : package[:jeans]
      !package[:jackets].nil? ? result[:jackets] = package[:jackets].collect{ |k| k + "," }.to_s : package[:jackets]
      !package[:dresses].nil? ? result[:dresses] = package[:dresses].collect{ |k| k + "," }.to_s : package[:dresses]
      !package[:basics].nil? ? result[:basics] = package[:basics].collect{ |k| k + "," }.to_s : package[:basics]
      !package[:colors].nil? ? result[:colors] = package[:colors].collect{ |k| k + "," }.to_s : package[:colors]
      !package[:labels].nil? ? result[:labels] = package[:labels].collect{ |k| k + "," }.to_s : package[:labels]
      !package[:saison].nil? ? result[:saison] = package[:saison].collect{ |k| k + "," }.to_s : package[:saison]

      result
    end

    def transform_param(search_key)
      if search_key =~ /^(j|J)(u|U)(n|N)(g|G)/
        search_key = 0
      elsif search_key =~ /^(m|M)(ä|Ä)(d|D)(c|C)(h|H)(e|E)(n|N)/ || search_key =~ /^(m|M)(a|A)(e|E)(d|D)(c|C)(h|H)(e|E)(n|N)/
        search_key = 1
      end
    end
    
end
