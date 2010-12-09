# To change this template, choose Tools | Templates
# and open the template in the editor.

class PrePayment < ActiveRecord::Base

  has_many  :users
  has_many  :bank_details

  def set_prepayment
    true
  end

  def premium_cancel
    true
  end

  def check_bank_balance
    true
  end

  def bank_details
    true
  end

  def export_all_not_confirmed
    true
  end

  
end
