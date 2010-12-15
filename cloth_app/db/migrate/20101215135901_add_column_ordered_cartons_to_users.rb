class AddColumnOrderedCartonsToUsers < ActiveRecord::Migration
  def self.up
    add_column  :users, :ordered_cartons, :boolean, :default => 0
  end

  def self.down
    remove_column :users, :ordered_cartons
  end
end
