class UpdateColumnsIntegerIntoFloat < ActiveRecord::Migration
  def self.up
    change_column :prices,  :shipping,  :float, :default => 11.0
    change_column :prices,  :handling,  :float, :default => 1.20
  end

  def self.down
    change_column :prices,  :shipping,  :integer
    change_column :prices,  :handling,  :integer
  end
end
