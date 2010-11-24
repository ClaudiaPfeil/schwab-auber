class AddCartonsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :cartons, :integer, :default => 5
  end

  def self.down
    remove_column :users, :cartons
  end
end
