class AddColumnReceivedToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :received, :tinyint
  end

  def self.down
    remove_column :orders, received
  end
end
