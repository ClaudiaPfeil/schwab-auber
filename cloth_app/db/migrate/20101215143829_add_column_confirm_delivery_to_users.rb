class AddColumnConfirmDeliveryToUsers < ActiveRecord::Migration
  def self.up
    add_column   :users, :confirmed_delivery, :boolean, :default => 0
  end

  def self.down
    remove_column :users, :confirmed_delivery
  end
end
