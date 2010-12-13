class RemovePrepaymentConfirmedFromBankDetails < ActiveRecord::Migration
  def self.up
    remove_column :bank_details, :prepayment_confirmed
    remove_column :bank_details, :balance
  end

  def self.down
    add_column  :bank_details, :prepayment_confirmed, :boolean
    add_column  :bank_details, :balance, :integer
  end
end
