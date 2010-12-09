# To change this template, choose Tools | Templates
# and open the template in the editor.
module Codebreaker

  class Payment

    def initialize(output)
      @output = output
    end

    def premium_cancel_membership
      @output.puts = 'Admin is informed by email'
    end

    def premium_confirms_prepayment
      @output.puts  = 'Premium user has payed membership'
    end

    def payment_receipt
      @output.puts  = 'Admin can export list'
    end

    def remember_payment
      @output.puts  = 'Remember payment'
    end

    def admin_confirms
      @output.puts  = 'Admin confirmed payment receipt'
    end

    def write_email
      @output.puts  = 'Check bank balance'
    end

    def master_visa_card
      @output.puts  = 'Master/Visa- Card'
    end

    def paypal
      @output.puts  = 'Paypal'
    end

    def prepayment
      @output.puts  = 'Prepayment'
    end
    
  end
  
end

