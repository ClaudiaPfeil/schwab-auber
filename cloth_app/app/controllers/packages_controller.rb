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
    @packages = Package.where("LEFT(packages.created_at,10) BETWEEN '#{formatted_mysql_date(Date.today - 24.hours)}' AND '#{Date.today}' ")
  end

  def new
    @package = Package.new()
  end

  def create
    @package = Package.new(prepare_package(params[:package]))
    
    if @package.save
      redirect_to packages_path(@package), :notice => I18n.t(:package_created)
    else
      @package = @package
      @notice = I18n.t(:package_not_created)
      render :action => 'new'
    end
    
  end

  def edit; end

  def update
    if @package.update_attributes(prepare_package(params[:package]))
      redirect_to packages_path(@package), :notice => I18n.t(:package_updated)
    else
      @package = @package
      @notice = I18n.t(:package_not_updated)
      render :action => 'edit'
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

  def search_remote
    search_key = params[:format]
    search_type = "Sex"
    @packages = Package.search_by_attributes(search_key, search_type)
    render :action => :index, :@packages => @packages
  end

  private

    def init_package
      init_current_object { @package = Package.find_by_id(params[:id]) }
    end

    def init_order_package
      init_current_object { @package = Package.find_by_id(params[:id])}
    end

    def init_current_object
      @current_object = yield
    end

    def prepare_package(package)
      result = { }
      amount = 0
      result[:serial_number] = package[:serial_number]
      result[:sex] = package[:sex]
      result[:notice] = package[:notice]
      result[:size] = package[:size]
      result[:next_size] = package[:next_size]
      
      result[:age] = package[:age]
      result[:amount_labels] = package[:amount_labels]
      result[:confirmed] = package[:confirmed]
      result[:accepted] = package[:accepted]
      result[:user_id] = package[:user_id]
      !package[:kind].nil? ? result[:kind] = package[:kind].collect{ |k| k + "," }.to_s : package[:kind]
      # Abfrage der Auswahl der Oberkategorie: Shirts, Blusen, Jeans, Jacken, Kleider&Röcke, Erstausstattung
      package[:kind].each do |kind|
        case kind
          when 'Shirts & Tops': result[:shirts] = ''
                                result[:shirts]+= package[:t_shirts].to_s + ' T-Shirt(s)' if package[:t_shirts].to_i > 0
                                result[:shirts]+= ', ' + package[:polo_shirts].to_s + ' Polo-Shirt(s)' if package[:polo_shirts].to_i > 0
                                result[:shirts]+= ', ' + package[:langarm_shirt].to_s + ' Langarm-Shirt(s)' if package[:langarm_shirt].to_i > 0
                                result[:shirts]+= ', ' + package[:fleece_shirt].to_s + ' Fleece-Shirt(s)' if package[:fleece_shirt].to_i > 0
                                result[:shirts]+= ', ' + package[:pullover].to_s + ' Pullover(s)' if package[:pullover].to_i > 0
                                amount += package[:t_shirts].to_i + package[:polo_shirts].to_i + package[:langarm_shirt].to_i + package[:fleece_shirt].to_i +  package[:pullover].to_i

          when 'Blusen & Hemden': result[:blouses] = ''
                                  result[:blouses] += package[:blouses].to_s + ' Bluse(n)' if package[:blouses].to_i > 0
                                  result[:blouses] += ', ' + package[:tunics].to_s + ' Tuniken' if package[:tunics].to_i > 0
                                  result[:blouses] += ', ' + package[:shirts].to_s + ' Shirts & Tops' if package[:shirts].to_i > 0
                                  amount += package[:blouses].to_i + package[:tunics].to_i + package[:shirts].to_i

          when 'Jacken':  result[:jackets] = ''
                          result[:jackets] += package[:fleece].to_s + ' Fleece Jacke(n)' if package[:fleece].to_i > 0
                          result[:jackets] += ', ' + package[:sweater].to_s + ' Sweatjacke(n)' if package[:sweater].to_i > 0
                          result[:jackets] += ', ' + package[:jersey].to_s + ' Strickjacke(n)' if package[:jersey].to_i > 0
                          result[:jackets] += ', ' + package[:snow].to_s + ' Schneejacke(n)' if package[:snow].to_i > 0
                          result[:jackets] += ', ' + package[:vest].to_s + ' Weste(n)' if package[:vest].to_i > 0
                          amount += package[:fleece].to_i + package[:sweater].to_i + package[:jersey].to_i + package[:snow].to_i + package[:vest].to_i
         
          when 'Jeans' :  result[:jeans] = ''
                          result[:jeans] += package[:pants].to_s + ' Hose(n)' if package[:pants].to_i > 0
                          result[:jeans] += ', ' + package[:jeans].to_s + ' Jeans' if package[:jeans].to_i > 0
                          result[:jeans] += ', ' + package[:overalls].to_s + ' Latzhose(n)' if package[:overalls].to_i > 0
                          result[:jeans] += ', ' + package[:rain_pants].to_s + ' Regenhose(n)' if package[:rain_pants].to_i > 0
                          result[:jeans] += ', ' + package[:snow_pants].to_s + ' Schneehose(n)' if package[:snow_pants].to_i > 0
                          result[:jeans] += ', ' + package[:bermudas].to_s + ' Bermudas' if package[:bermudas].to_i > 0
                          result[:jeans] += ', ' + package[:leggins].to_s + ' Leggins' if package[:leggins].to_i > 0
                          result[:jeans] += ', ' + package[:shorts].to_s + ' Shorts' if package[:shorts].to_i > 0
                          result[:jeans] += ', ' + package[:sweat_pants].to_s + ' Sweat-Hose(n)' if package[:sweat_pants].to_i > 0
                          result[:jeans] += ', ' + package[:trunks].to_s + ' Sporthose(n)' if package[:trunks].to_i > 0
                          result[:jeans] += ', ' + package[:tracksuit].to_i > 1 ? package[:tracksuit].to_s + ' Trainingsanzüge' : package[:tracksuit].to_s + ' Trainingsanzug' if package[:tracksuit].to_i > 0
                          amount += package[:pants].to_i + package[:jeans].to_i + package[:overalls].to_i + package[:rain_pants].to_i + package[:snow_pants].to_i + package[:bermudas].to_i + package[:leggins].to_i + package[:shorts].to_i + package[:sweat_pants].to_i + package[:trunks].to_i +  package[:tracksuit].to_i
         
          when 'Kleider & Röcke' : result[:dresses] = ''
                                   result[:dresses] += ', ' + package[:skirt].to_s + ' Röcke' if package[:skirt].to_i > 0
                                   result[:dresses] += ', ' + package[:dresses].to_s + ' Kleider' if package[:dresses].to_i > 0
                                   amount += package[:skirt].to_i + package[:dresses].to_i
        
          when 'Erstausstattung' : result[:basics] = ''
                                   result[:basics] += ', ' + package[:bodies].to_s + ' Bodies' if package[:bodies].to_i > 0
                                   result[:basics] += ', ' + package[:romper_suits].to_s + ' Strampler' if package[:romper_suits].to_i > 0
                                   result[:basics] += ', ' + package[:pyjamas].to_s + ' Schlafanzüge' if package[:pyjamas].to_i > 0
                                   result[:basics] += ', ' + package[:sleeping_bags].to_s + ' Schlafsäcke' if package[:sleeping_bags].to_i > 0
                                   amount += package[:bodies].to_i + package[:romper_suits].to_i + package[:pyjamas].to_i + package[:sleeping_bags].to_i
        end
      end
      # ---Ende---
      result[:amount_clothes] = amount
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

    def formatted_mysql_date(date)
      date.strftime("%Y-%m-%d") unless date.nil?
    end
    
end
