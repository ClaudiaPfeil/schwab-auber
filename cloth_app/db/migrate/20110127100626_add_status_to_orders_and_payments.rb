class AddStatusToOrdersAndPayments < ActiveRecord::Migration
  def self.up
    add_column :orders, :status, :integer, :default => 0
    add_column :payments, :status, :string, :default => 0
  end

  def self.down
    remove_column :orders, :status
    remove_column :payments, :status
  end
end
