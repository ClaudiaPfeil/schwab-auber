# Titel:  Hilfsmethoden für das Profil
# Autor:  Claudia Pfeil
# Datum:  24.11.2010

module ProfilesHelper

  def package_konto(profile)
    pack_count  = profile.packages.count
    ord_count   =  profile.orders.count
    success     = link_to(I18n.t(:order_more_cartons))
    failure     = "Sie schulden noch #{} Kleiderpakete bevor sie wieder bestellen dürfen!"

    pack_count < ord_count ? failure : success
  end
  
end
