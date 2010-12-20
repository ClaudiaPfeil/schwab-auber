class AddColumnCanceledToUsers < ActiveRecord::Migration
  def self.up
    add_column  :users, :canceled, :boolean, :default => 0
  end

  def self.down
    remove_column :users, :canceled
  end
end
