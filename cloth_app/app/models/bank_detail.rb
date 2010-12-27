# Titel:  Model für Bankverbindung & Zahlungsinfos
# Autor:  Claudia Pfeil
# Datum:  09.12.10

class BankDetail < ActiveRecord::Base
  include Cms

  belongs_to  :user
  attr_reader :upgrade
                

  def is_destroyable?
    false
  end

  def get_contents(category)
    get_content(category)
  end

end
