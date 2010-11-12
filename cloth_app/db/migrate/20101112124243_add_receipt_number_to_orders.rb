class AddReceiptNumberToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :bill_number, :string
    add_column :packages, :serial_number, :string

  end

  def self.down
    remove_column :orders, :bill_number
    remove_column :packages, :serial_number
  end
end
