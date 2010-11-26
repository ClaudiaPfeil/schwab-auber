class CreateTablePricesAndAddColumnPremiumPeriod < ActiveRecord::Migration
  def self.up
    add_column  :users, :premium_period,  :date
  end

  def self.down
    remove_column :users, :premium_period
  end
end
