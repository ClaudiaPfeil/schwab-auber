# To change this template, choose Tools | Templates
# and open the template in the editor.

class ProfilesController < ApplicationController  
  before_filter :init_profile, :action => [:show, :edit, :update, :destroy, :order_cartons]
  
  SEND_NAME2 = "DHL Online Frankierung"
  SEND_COUNTRY = "DEU"
  PRODUCT = "PAECK.DEU"

  def index
    user = User.find_by_id(current_user.id) if current_user
    (user.is? :admin)? @profiles = User.all : @profile = user if user
  end

  def show; end

  def new
    @profile = User.new()
  end

  def create
    @profile = User.new(params[:profile])
    if @profile.save
      redirect_to profiles_path, :notice => I18n.t(:profile_created)
    else
      @profile = @profile
      @notice = I18n.t(:profile_not_created)
      render :action => 'new'
    end
  end

  def edit; end

  def update; end

  def destroy
    unless @profile.is_premium?
      @profile.destroy if @profile.is_destroyable?
      destroy_packages
    else
      # Premium Account erst nach Ablauf der Mitgliedschaft löschen
      # die Kleiderpakete auch erst nach Ablauf der Mitgliedschaft löschen
      if @profile.premium_is_destroyable?
        @profile.destroy 
        destroy_packages
      else
        # ToDo: Speichern der Kündigung der Mitgliedschaft
        @profile.udpate_attribute(:canceled, 1)
      end

    end
    
  end

  def search
    search_type, search_key = params[:search_type], params[:search_key]
    @profiles = User.search_by_attributes(search_key, search_type) unless search_type.nil? || search_key.nil?
  end

  def history
    @packages = self.user.packages
    @orders   = self.user.orders
  end

  # Neue Versandkartonage anfordern
  def order_cartons
    UserMailer.order_cartons(@profile).deliver
    # speichern in der DB zur Anzeige im Dashboard
    @profile.update_attribute(:ordered_cartons, 1)
    redirect_to edit_profile_path(@profile)
  end

  # Kunden werben Kunden
  # eine Einladungs-E-Mail wird an Freunden gesendet, wie eine Empfehlung
  def invite_friend
    friend = params[:invite_friend]
    profile = User.find_by_id(friend[:user_id])

    UserMailer.send_invitation(friend, profile).deliver
    redirect_to edit_profile_path(friend[:user_id])
  end

  # Historie aller Profile exportieren als CSV
  def export_histories
    puts " Exportieren aller Profil Historien sofern Admin: " + (current_user.is? :admin).to_s
    @profiles = User.all if current_user.is? :admin

    if @profiles
      puts "\n Alle Profile" 
      path = 'export/'
      name = 'alle_profile_historien.csv'
      File.new(path + name, "w").path
      input = ""

      @profiles.each do |profi|
        puts "\n jedes Profil"
        File.open(path+name, "w") do |histories|
          
          input << "Name, Vorname, Kunden-Nr.,\n"
          input << "#{profi.last_name}, #{profi.first_name}, #{profi.user_number}\n"
          puts " Erste Zeile: " + input.to_s
          packages = profi.packages
          orders = profi.orders

          unless packages.blank?
            input << "Pakete-Historie," + "\n"
            input << "Paket-Nr., Erstellt am, Anzahl Kleider, Geschlecht, Beschreibung, Labels," + "\n"
            packages.each do |package|
              input << "#{package.serial_number},#{formatted_date(package.created_at)},#{package.amount_clothes},#{package.sex == true ? "Mädchen" : "Junge"},"
              input << "#{package.notice.gsub(",", " ")}," unless package.notice.nil?
              input << "#{package.label.gsub(",", " ").gsub("--", " ")}," unless package.label.nil?
              input << "\n"
            end
          end
          
          unless orders.blank?
            input << "\n"+ "Bestell-Historie," + "\n"
            input << "Bestell-Nr., Bestellt am, Bewerted am , Bewertung, Angekommen?," + "\n"
            orders.each do |order|
              input << "#{order.order_number},#{formatted_date(order.created_at)}, #{formatted_date(order.eva_date_created_at)},"
              input << "#{I18n.t(order.evaluation.to_sym)}," if order.evaluation
              input << "#{order.received == true ? "Nein" : "Ja"}" + "\n"
            end

            input << "\n"
          end
          puts input
          histories.write(input) unless input.blank?
        end
      end
      send_file(path+name)
    else
      puts "Kein Admin, keine Profile Historien! " + (current_user.is? :admin).to_s
    end

  end

  def export_cartons
    @profiles = User.where(:ordered_cartons => 1).to_a if current_user.is? :admin
    if @profiles
      path = 'export/'
      name = 'alle_cartonagen_bestellungen.csv'
      File.new(path + name, "w").path
      input = ""

      @profiles.each do |profi|
        addresses = profi.addresses
        File.open(path+name, "w") do |cartons|

          unless addresses.blank?
            input << "\n"+ "Kartonagen-Bestellungen," + "\n"
            input << "Vorname und Nachname, Empfänger, Zusatz, Straße und Hausnummer, Postleitzahl, Stadt, Land, Lieferanschrift," + "\n"

            addresses.each do |address|
              input << "#{profi.first_name + ' ' + profi.last_name}, #{address.receiver}, #{address.receiver_additional}, #{address.street_and_number}, #{address.postcode}, #{address.town}, #{address.land}, #{address.kind == true ? "nein" : "ja"}," + "\n"
            end

            input << "\n"
          end

          cartons.write(input) if input
        end
      end
      send_file(path+name)
    end
  end

  def export_addresses
    orders = Order.where("orders.created_at like '%#{Date.today}%'")
    
    if orders
      path = 'export/'
      name = 'alle_anschriften_der_heutigen_bestellungen.csv'
      File.new(path + name, "w").path
      input = "\n"+ "SEND_NAME1, SEND_NAME2, SEND_STREET, SEND_HOUSENUMBER, SEND_PLZ, SEND_CITY, SEND_COUNTRY, RECV_NAME1, RECV_NAME2, RECV_STREET, RECV_HOUSENUMBER, RECV_PLZ, RECV_CITY, RECV_COUNTRY, PRODUCT, COUPON" + "\n"

      orders.each do |order|
        
        profile = order.user
        rec_address = get_bill_address(profile)
        package = order.package
        sender = package.user
        coupon = ""
        
        unless rec_address.blank?
          File.open(path+name, "w") do |file|
            recv = rec_address.first.street_and_number.split(" ")
            sender_address = get_delivery_address(sender)
            sender_tmp = sender_address.first.street_and_number.split(" ")
            input << "#{sender.first_name + ' ' + sender.last_name}, #{sender_address.first.receiver_additional ? sender_address.first.receiver_additional : SEND_NAME2}, #{sender_address.first.street_and_number.gsub(sender_tmp.last,"")}, #{sender_tmp.last}, #{sender_address.first.postcode}, #{sender_address.first.town}, #{SEND_COUNTRY},#{profile.first_name + ' ' + profile.last_name}, #{rec_address.first.receiver_additional ? rec_address.first.receiver_additional : SEND_NAME2},#{rec_address.first.street_and_number.gsub(recv.last,"")}, #{recv.last}, #{rec_address.first.postcode}, #{rec_address.first.town}, #{SEND_COUNTRY}, #{PRODUCT}, #{coupon}\n"
            
            file.write(input) if input
          end
        end
      end
      send_file(path+name)
    end
  end

  private

    def init_profile
      init_current_object { @profile = User.find_by_id(params[:id]) }
    end

    def init_current_object
      @current_object = yield
    end

    def destroy_packages
      @profile.packages.each do |package|
        package.destroy if package.is_destroyable?
      end
      UserMailer.cancel_info(@profile).deliver
      redirect_to profiles_path, :notice => I18n.t(:profile_destroyed)
    end

    def formatted_date(date)
      date.strftime("%d.%m.%Y") unless date.nil?
    end

    def get_delivery_address(sender)
    addresses = sender.addresses unless sender.blank?

    if addresses.count > 1
      addresses.each do |address|
        if address.kind == 0
          return address
        end
      end
    else
      return addresses
    end
  end

  def get_bill_address(receiver)
    addresses = receiver.addresses unless receiver.blank?

    if addresses.count > 1
      addresses.each do |address|
        if address.kind == 1
          return address
        end
      end
    else
      return addresses
    end
  end

end
