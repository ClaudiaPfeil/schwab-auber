class UpdateColumnContinueMembership < ActiveRecord::Migration
  def self.up
    change_column :users, :continue_membership, :boolean, :default => true
  end

  def self.down
    change_column :users, :continue_membership, :boolean
  end
end
