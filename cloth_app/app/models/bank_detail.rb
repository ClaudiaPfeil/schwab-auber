# Titel:  Model für Bankverbindung & Zahlungsinfos
# Autor:  Claudia Pfeil
# Datum:  09.12.10

class BankDetail < ActiveRecord::Base
  belongs_to  :user

  def is_destroyable?
    false
  end


end
