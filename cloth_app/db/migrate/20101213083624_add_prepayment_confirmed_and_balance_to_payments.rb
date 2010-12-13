class AddPrepaymentConfirmedAndBalanceToPayments < ActiveRecord::Migration
  def self.up
    add_column  :payments, :prepayment_confirmed, :boolean, :default => 0
    add_column  :payments, :balance, :integer
  end

  def self.down
    remove_column :payments, :prepayment_confirmed
    remove_column :payments, :balance
  end
end
