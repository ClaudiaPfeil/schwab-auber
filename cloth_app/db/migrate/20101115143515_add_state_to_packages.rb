class AddStateToPackages < ActiveRecord::Migration
  def self.up
    add_column :packages, :state, :tinyint, :default => '0'
  end

  def self.down
    remove_column :packages, :state
  end
  
end
