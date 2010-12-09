# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'codebreaker'

module Codebreaker

  describe "#premium choose prepayment" do
   
    it "should inform admin and that payment is done" do
      output = double('output')
      prepayment = PrePayment.new(output)
      output.should_receive(:puts).with('Your invitation e-mail was send')
      prepayment.set_preypayment
    end
    
  end

  describe "#premium cancels membership" do
    it "should inform the admin" do
      output = double('output')
      prepayment = PrePayment.new(output)
      output.should_receive(:puts).with('Your invitation e-mail was send')
      prepayment.premium_cancel
    end

  end

  describe "#admin confirms bank balance" do
    it "should send a remember to the user if there is no confirmation within 5 days" do
      output = double('output')
      prepayment = PrePayment.new(output)
      output.should_receive(:puts).with('Your invitation e-mail was send')
      prepayment.check_bank_balance
    end
  end

  describe "#user crud bank details" do
    it "should show the user_number for the reason for payment" do
      output = double('output')
      prepayment = PrePayment.new(output)
      output.should_receive(:puts).with('Your invitation e-mail was send')
      prepayment.bank_details
    end
  end

  describe "#check not confirmed prepayments" do
    it "should export all in a list" do
      output = double('output')
      prepayment = PrePayment.new(output)
      output.should_receive(:puts).with('Your invitation e-mail was send')
      prepayment.export_all_not_confirmed
    end
   
  end
  
end



