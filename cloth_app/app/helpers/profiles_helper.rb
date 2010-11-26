# Titel:  Hilfsmethoden für das Profil
# Autor:  Claudia Pfeil
# Datum:  24.11.2010

module ProfilesHelper

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

  def get_settings(profile)
    result  = []
    profile.option.each do |s|
      if s == true
        if s.to_s == "first_letter_of_first_name" || s.to_s == "first_name"
          result << profile.first_name
        elsif s.to_s == "first_letter_of_last_name"
          result  << profile.last_name
        else
          result  << profile.attributes[s.to_s]
        end
      end
    end
      
    result
  end
  
end