class WelcomeController < ApplicationController
  include Cms

  def home
    @contents = get_content("Welcome")
  end

  def index
    flash.keep # Will persist all flash values. You can also use a key to keep only that value: flash.keep(:notice)
    redirect_to welcome_url
  end

  def membership
    @user = User.find_by_id(current_user.id)
  end

  # Methode: dashboard
  # Beschreibung: export aller Profile-Historien
  def dashboard

  end

  def import_coupons
    # Datei in Verzeichnis Import kopieren
    post = DataFile.save(params[:coupons])
    
    # Datei auslesen und in die Tabelle coupons einlesen
    data = ''
    File.open('doc/'+post, "r") do |file|
      while (line = file.gets)        
        data += line
        Coupon.create({:code => data})
      end
    end
    
    # Datei löschen
    DataFile.cleanup("doc",post)
    redirect_to dashboard_path, :notice => "Gutscheine erfolgreich importiert"
  end

  def help
    @contents = get_content("Help")
  end

  def contact
    @contents = get_content("Contact")
    @contact = Contact.new()
  end

  def get_in_contact
    
  end

  def impressum
    @contents = get_content("Impressum")
  end
  
end