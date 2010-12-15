# To change this template, choose Tools | Templates
# and open the template in the editor.

class ProfilesController < ApplicationController
  
  before_filter :init_profile, :action => [:show, :edit, :update, :destroy, :order_cartons]

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
      render :action => 'new', :notice => I18n.t(:profile_not_created)
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
        # ToDo: Speichern des Lösch-Auftrages in einem cronjob, der nach Ende der Mitgliedschaft ausgeführt wird
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
    @profile.update_attribute(:ordered_cartons, 0)
    redirect_to edit_profile_path(@profile)
  end

  # Kunden werben Kunden
  # eine Einladungs-E-Mail wird an Freunden gesendet, wie eine Empfehlung
  def invite_friend
    friend = params[:invite_friend]
    profile = User.find_by_id(friend[:user_id])

    UserMailer.send_invitation(friend, profile).deliver
    redirect_to profile_path(profile)
  end

  # Historie aller Profile exportieren als CSV
  def export_histories
    @profiles = User.all if current_user.is? :admin
    if @profiles
      path = 'export/'
      name = 'alle_profile_historien.csv'
      File.new(path + name, "w").path
      input = ""

      @profiles.each do |profi|
        File.open(path+name, "w") do |histories|

          packages = profi.packages
          orders = profi.orders
          
          unless packages.blank?
            input << "Pakete-Historie," + "\n"
            input << "Paket-Nr., Erstellt am, Anzahl Kleider, Geschlecht, Beschreibung, Labels," + "\n"
            packages.each do |package|
              input << "#{package.serial_number},#{formatted_date(package.created_at)},#{package.amount_clothes},#{package.sex == true ? "Mädchen" : "Junge"},#{package.notice.gsub(",", " ")},#{package.label.gsub(",", " ").gsub("--", " ")}," + "\n"
            end
          end
          
          unless orders.blank?
            input << "\n"+ "Bestell-Historie," + "\n"
            input << "Bestell-Nr., Bestellt am, Bewerted am , Bewertung, Angekommen?," + "\n"
            orders.each do |order|
              input << "#{order.order_number},#{formatted_date(order.created_at)}, #{formatted_date(order.eva_date_created_at)}, #{I18n.t(order.evaluation.to_sym)}, #{order.received == true ? "Nein" : "Ja"}" + "\n"
            end

            input << "\n"
          end
          
          histories.write(input) if input
        end
      end
      send_file(path+name) 
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
end
