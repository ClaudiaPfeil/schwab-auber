# Titel:  Model für Bankverbindung & Zahlungsinfos
# Autor:  Claudia Pfeil
# Datum:  09.12.10

class BankDetail < ActiveRecord::Base
  include Cms

  belongs_to  :user

  attr_accessor :PSPID, :ORDERID, :AMOUNT, :CURRENCY, :LANGUAGE, :EMAIL, :SHASIGN, :TITLE, :BGCOLOR, :TXTCOLOR,
                :TBLBGCOLOR, :TBLTXTCOLOR, :BUTTONBGCOLOR, :BUTTONTXTCOLOR, :LOGO, :FONTTYPE, :TP, :PM,
                :BRAND, :WIN3DS, :PMLIST, :PMLISTTYPE, :HOMEURL, :CATALOGURL, :COMPLUS, :PARAMPLUS, :PARAMVAR, :ACCEPTURL,
                :DECLINEURL, :EXCEPTIONURL, :CANCELURL, :OPERATION, :USERID, :ALIAS, :ALIASUSAGE, :ALIASOPERATION
                

  def is_destroyable?
    false
  end

  def get_contents(category)
    get_content(category)
  end

end
