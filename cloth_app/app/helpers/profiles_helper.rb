# Titel:  Hilfsmethoden für das Profil
# Autor:  Claudia Pfeil
# Datum:  24.11.2010

module ProfilesHelper
  include CanCan

  def outstanding_packages(profile)
    p = profile.packages.count
    o = profile.orders.count

    o - (p + 1)
    
  end

  def credit_packages(profile)
    p = profile.packages.count
    o = profile.orders.count

    (p + 1) - o
  end

  def cartons_konto(profile)
    pack_count  =   profile.packages.count
    ord_count   =   profile.orders.count
    success     =   "Sie haben noch #{credit_packages(profile)} Bestellung(en) offen bevor sie neue Kleiderpakete einstellen müssen."
    failure     =   "Sie schulden noch #{outstanding_packages(profile)} Kleiderpakete bevor sie wieder bestellen dürfen!"

    pack_count < ord_count ? failure : success
  end

  def more_cartons?(profile)
    profile.cartons <= profile.option.cartons ?   link_to(I18n.t(:order_more_cartons), order_cartons_profile_path(profile)) : ""
  end

  # Methode: get_settings
  # Beschreibung: gibt die Profil-Einstellungen des Nutzers als Array zurück
  def get_settings(profile)
    result  = []

    profile.option.attribute_names.each do |s|
      if profile.option.attributes[s.to_s] == true
        result  << s.to_s
      end
    end
    
    result
  end

  def create_list_view(profile, name)
    result = ""
    if name.to_s == "name"
      result = profile.name
    elsif name.to_s == "sex"
      profile.sex == true ? result = "männlich" : result = "weiblich"
    elsif name.to_s == "first_letter_of_first_name" && !(current_user.is? :admin)
      result = profile.first_name.first + " " + profile.last_name
    elsif name.to_s == "first_letter_of_last_name" && !(current_user.is? :admin)
      result = profile.first_name + " " + profile.last_name.first
    elsif name.to_s == "membership"
      profile.membership == true ? result = I18n.t(:premium) : result = I18n.t(:base)
    else 
      result = profile.attributes[name.to_s]
    end

    result
  end

  def get_table_cols(current_user)
    (current_user.is? :admin) ? ListView.get_table_columns(User, [:name, :sex, :telephone, :membership]) : get_settings(current_user)
  end
  
end
