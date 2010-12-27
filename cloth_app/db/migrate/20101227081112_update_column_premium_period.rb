class UpdateColumnPremiumPeriod < ActiveRecord::Migration
  def self.up
      change_column :users, :premium_period, :boolean, :default => 0
  end

  def self.down
      change_column :users, :premium_period, :date
  end
end
