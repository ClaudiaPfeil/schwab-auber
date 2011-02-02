# To change this template, choose Tools | Templates
# and open the template in the editor.

class Payment < ActiveRecord::Base
  belongs_to :user
  belongs_to :package
  belongs_to :order

  attr_accessor :email, :message
  attr_accessor :PSPID, :ORDERID, :AMOUNT, :CURRENCY, :LANGUAGE, :EMAIL, :SHASIGN, :TITLE, :BGCOLOR, :TXTCOLOR,
                :TBLBGCOLOR, :TBLTXTCOLOR, :BUTTONBGCOLOR, :BUTTONTXTCOLOR, :LOGO, :FONTTYPE, :TP, :PM,
                :BRAND, :WIN3DS, :PMLIST, :PMLISTTYPE, :HOMEURL, :CATALOGURL, :COMPLUS, :PARAMPLUS, :PARAMVAR, :ACCEPTURL,
                :DECLINEURL, :EXCEPTIONURL, :CANCELURL, :OPERATION, :USERID, :ALIAS, :ALIASUSAGE, :ALIASOPERATION, :TXTOKEN

  HOME_URL = 'http://dev.kidskarton.de/'
  CATALOG_URL = HOME_URL + 'serach'
  ACCEPT_URL = HOME_URL + 'accept'
  DECLINE_URL = HOME_URL + 'decline'
  EXCEPTION_URL = HOME_URL + 'exception'
  CANCEL_URL   = HOME_URL + 'cancel'
  BGCOLOR = "#336699"
  BUTTONBGCOLOR = "#336699"
  BUTTONTXTCOLOR = "#09f"
  BRAND = "VISA"
  BRAND_PAYPAL = "PAYPAL"
  BRAND_DIRECT = "Direct Debits DE"
  PSPID = "pauberPROD"
  OPERATION = 'SAL'
  TBLBGCOLOR = '#CCCC99'
  PMLISTTYPE = "2"
  PMLIST = "VISA;MasterCard"
  WIN3DS = "POPUP"
  PM = "PAYPAL"
  PM_CARD = "CreditCard"
  PM_DIRECT = "Direct Debits DE"
  TP = 'http://dev.kidskarton.de/layouts/application'
  TITLE = 'KidsKarton.de'
  TXTCOLOR = '#222222'
  CURRENCY = 'EUR'
  FONTTYPE = 'Helvetica, sans-serif'
  HOMEURL = 'http://dev.kidskarton.de'
  LANGUAGE = 'de_DE'
  LOGO = 'http://dev.kidskarton.de/images/logo.gif'
  TXTOKEN = "INIT"

  def is_destroyable?
    false
  end

  def bill_premiums
    premiums = User.where(:membership => true)
    premiums.each do |premium|
      # status der Bezahlung prüfen
      last_bill = premium.payments.order_by("paied Desc").first
      case premium.period
        when  3 :   bill unless last_bill.between(Date.today, Date.today-3.months) && paied == true
        when  6 :   bill unless last_bill.between(Date.today, Date.today-6.months) && paied == true
        when 12 :   bill unless last_bill.between(Date.today, Date.today-1.years)  && paied == true
      end
    end
  end

  private
  
end
