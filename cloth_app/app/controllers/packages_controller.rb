class PackagesController < ApplicationController
  before_filter :init_package, :action => [:show, :edit, :update, :destroy]
  before_filter :init_order_package, :action => [:order]

  # Alle Kunden dürfen alle Kleiderpakete sehen, egal ob Basis, Premium oder Gast
  def index
    @packages = Package.where(:state => 0)
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
      # count down cartons
      @package.user.count_down
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
    # count up cartons
    @package.user.count_up
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

  # create order
  # set status to ordered = 1 and to paied = 2 if transaction was successfully
  def order
    @order = Order.new(:package_number => @package.serial_number,
                       :package_id     => @package.id,
                       :user_id        => current_user.id,
                       :status         => 1
                      )
  
    @order.package.accepted = 1
    @order.package.confirmed = 1
    @order.package.user.accepted = 1
    
    if @order.check_change_principle == true && @order.check_holidays == true
      @order.order_number  = @order.get_order_number
      @order.bill_number = @order.get_bill_number
      if @order.save!
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
    search_key = ""
    search_type = ""
    
    params[:format].to_s.include?(",") ? search_keys = params[:format].split(",") : search_keys = params[:format]
    search_keys.delete_at(0) if search_keys.count > 1
    
    search_keys.each do |key|
      tmp = key.split("=")
      search_type << tmp.first.to_s + " " if tmp
      search_key  << tmp.second.to_s + " " if tmp
    end
    
    search_key = search_key.split(" ")
    search_type = search_type.split(" ")
    
    search_key.each_with_index do |key, i|
      @packages = Package.search_by_attributes(key, search_type[i])
    end
    
    render :action => :index, :locales => {:@packages => @packages}
    
  end

  def search_remote_2
    search_key = ""
    search_type = ""

    if params[:format]
      search_keys = params[:format].split(",")
      amount = search_keys.count
      sql = ""
      search_keys.each_with_index do |key, index|
        (amount > 1 && index < amount-1) ? sql << "#{key.to_s} OR " : sql << "#{key.to_s}"
      end
      @packages = Package.where(sql).default_ordered
    else
      @packages = Package.all.default_ordered
    end

    #    respond_to do |format|
#      format.html {render :partial => "packages", :locales => @packages, :content-type => 'application/html'}
#      if request.xhr?
#        format.js do
#          render :update do |page|
#            page.insert_html @packages, @packages, :partial => 'packages'
#          end
#        end
#      end
#    end
    render :partial => "packages", :locales => {:@packages => @packages}
    
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
      !package[:kind].nil? ? result[:kind] = package[:kind].collect{ |k| (k + ",") unless k.blank? }.to_s : package[:kind]
      # Abfrage der Auswahl der Oberkategorie: Shirts, Blusen, Jeans, Jacken, Kleider&Röcke, Erstausstattung
      package[:kind].each do |kind|
        case kind
          # :tops, :t_shirts, :polo_shirts, :langarm_shirt, :fleece_shirt, :pullover,
          when 'Shirts & Tops': result[:shirts] = ''
                                result[:shirts]+= package[:tops].to_s + ' Top(s)' if package[:tops].to_i > 0
                                result[:shirts]+= (', ' + package[:t_shirts].to_s + ' T-Shirt(s)') if package[:t_shirts].to_i > 0
                                result[:shirts]+= (', ' + package[:polo_shirts].to_s + ' Polo-Shirt(s)') if package[:polo_shirts].to_i > 0
                                result[:shirts]+= (', ' + package[:langarm_shirt].to_s + ' Langarm-Shirt(s)') if package[:langarm_shirt].to_i > 0
                                result[:shirts]+= (', ' + package[:fleece_shirt].to_s + ' Fleece-Shirt(s)') if package[:fleece_shirt].to_i > 0
                                result[:shirts]+= (', ' + package[:pullover].to_s + ' Pullover(s)') if package[:pullover].to_i > 0
                                amount += package[:tops].to_i + package[:t_shirts].to_i + package[:polo_shirts].to_i + package[:langarm_shirt].to_i + package[:fleece_shirt].to_i +  package[:pullover].to_i

          when 'Blusen & Hemden': result[:blouses] = ''
                                  result[:blouses] += package[:blusen].to_s + ' Bluse(n)' if package[:blusen].to_i > 0
                                  result[:blouses] += (', ' + package[:tuniken].to_s + ' Tuniken') if package[:tuniken].to_i > 0
                                  result[:blouses] += (', ' + package[:shirtstops].to_s + ' Shirts & Tops') if package[:shirtstops].to_i > 0
                                  amount += package[:blusen].to_i + package[:tuniken].to_i + package[:shirtstops].to_i

          when 'Jacken':  result[:jackets] = ''
                          result[:jackets] += package[:fleecejacke].to_s + ' Fleece Jacke(n)' if package[:fleecejacke].to_i > 0
                          result[:jackets] += (', ' + package[:sweatjacke].to_s + ' Sweatjacke(n)') if package[:sweatjacke].to_i > 0
                          result[:jackets] += (', ' + package[:strickjacke].to_s + ' Strickjacke(n)') if package[:strickjacke].to_i > 0
                          result[:jackets] += (', ' + package[:schneejacke].to_s + ' Schneejacke(n)') if package[:schneejacke].to_i > 0
                          result[:jackets] += (', ' + package[:weste].to_s + ' Weste(n)') if package[:weste].to_i > 0
                          amount += package[:fleecejacke].to_i + package[:sweatjacke].to_i + package[:strickjacke].to_i + package[:schneejacke].to_i + package[:weste].to_i
         
          when 'Jeans' :  result[:jeans] = ''
                          result[:jeans] += package[:hosen].to_s + ' Hose(n)' if package[:hosen].to_i > 0
                          result[:jeans] += (', ' + package[:jeans].to_s + ' Jeans') if package[:jeans].to_i > 0
                          result[:jeans] += (', ' + package[:latzhosen].to_s + ' Latzhose(n)') if package[:latzhosen].to_i > 0
                          result[:jeans] += (', ' + package[:regenhosen].to_s + ' Regenhose(n)') if package[:regenhosen].to_i > 0
                          result[:jeans] += (', ' + package[:schneehosen].to_s + ' Schneehose(n)') if package[:schneehosen].to_i > 0
                          result[:jeans] += (', ' + package[:bermudas].to_s + ' Bermudas') if package[:bermudas].to_i > 0
                          result[:jeans] += (', ' + package[:leggins].to_s + ' Leggins') if package[:leggins].to_i > 0
                          result[:jeans] += (', ' + package[:shorts].to_s + ' Shorts') if package[:shorts].to_i > 0
                          result[:jeans] += (', ' + package[:sweathosen].to_s + ' Sweat-Hose(n)') if package[:sweathosen].to_i > 0
                          result[:jeans] += (', ' + package[:sporthosen].to_s + ' Sporthose(n)') if package[:sporthosen].to_i > 0
                          result[:jeans] += (', ' + (package[:trainingsanzug].to_i > 1 ? package[:trainingsanzug].to_s + ' Trainingsanzüge' : package[:trainingsanzug].to_s + ' Trainingsanzug')) if package[:trainingsanzug].to_i > 0
                          amount += package[:hosen].to_i + package[:jeans].to_i + package[:latzhosen].to_i + package[:regenhosen].to_i + package[:schneehosen].to_i + package[:bermudas].to_i + package[:leggins].to_i + package[:shorts].to_i + package[:sweathosen].to_i + package[:sporthosen].to_i +  package[:trainingsanzug].to_i
         
          when 'Kleider & Röcke' : result[:dresses] = ''
                                   result[:dresses] += (', ' + package[:kleiderröcke].to_s + ' Röcke') if package[:kleiderröcke].to_i > 0
                                   result[:dresses] += (', ' + package[:kleider].to_s + ' Kleider') if package[:kleider].to_i > 0
                                   amount += package[:kleiderröcke].to_i + package[:kleider].to_i
        
          when 'Erstausstattung' : result[:basics] = ''
                                   result[:basics] += (', ' + package[:bodies].to_s + ' Bodies') if package[:bodies].to_i > 0
                                   result[:basics] += (', ' + package[:strampler].to_s + ' Strampler') if package[:strampler].to_i > 0
                                   result[:basics] += (', ' + package[:schlafanzüge].to_s + ' Schlafanzüge') if package[:schlafanzüge].to_i > 0
                                   result[:basics] += (', ' + package[:schlafsäcke].to_s + ' Schlafsäcke') if package[:schlafsäcke].to_i > 0
                                   amount += package[:bodies].to_i + package[:strampler].to_i + package[:schlafanzüge].to_i + package[:schlafsäcke].to_i
        end
      end
      # ---Ende---
      result[:amount_clothes] = amount
      !package[:colors].nil? ? result[:colors] = package[:colors].collect{ |k| (k + ",") unless k.blank?}.to_s : package[:colors]
      !package[:label].nil? ? result[:label] = package[:label].collect{ |k| (k + ",") unless k.blank? }.to_s : package[:label]
      !package[:saison].nil? ? result[:saison] = package[:saison].collect{ |k| (k + ",") unless k.blank? }.to_s : package[:saison]
      
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
