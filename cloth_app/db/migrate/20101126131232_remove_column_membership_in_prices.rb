class RemoveColumnMembershipInPrices < ActiveRecord::Migration
  def self.up
    remove_column :prices,  :membership
  end

  def self.down
    add_column  :prices,  :membership,  :float
  end
end
