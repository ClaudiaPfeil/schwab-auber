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
                :DECLINEURL, :EXCEPTIONURL, :CANCELURL, :OPERATION, :USERID, :ALIAS, :ALIASUSAGE, :ALIASOPERATION

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

    def bill
      ogone = [ {:PSPID => 'pauber'},
                {:ORDERID  =>  ''},
                {:AMOUNT =>  ''},
                {:LANGUAGE => ''},
                {:EMAIL  => ''},
                {:SHASIGN  => ''},
                {:TITLE  => ''},
                {:BGCOLOR => ''},
                {:TXTCOLOR => ''},
                {:TBLBGCOLOR => ''},
                {:TBLTXTCOLOR => ''},
                {:BUTTONBGCOLOR => ''},
                {:BUTTONTXTCOLOR => ''},
                {:LOGO => ''},
                {:FONTTYPE => ''},
                {:TP => ''},
                {:PM => ''},
                {:BRAND => ''},
                {:WIN3DS => ''},
                {:PMLIST => ''},
                {:PMLISTTYPE => ''},
                {:HOMEURL => ''},
                {:CATALOGURL => ''},
                {:COMPLUS => ''},
                {:PARAMPLUS => ''},
                {:PARAMVAR => ''},
                {:ACCEPTURL => ''},
                {:DECLINEURL => ''},
                {:EXCEPTIONURL => ''},
                {:CANCELURL => ''},
                {:OPERATION => ''},
                {:USERID => ''}
              ]
              
      PaymentsController.new.send_to_ogone(ogone)
    end
  
end
