class AddColumnContinueMembershipToUsers < ActiveRecord::Migration
  def self.up
    add_column  :users, :continue_membership, :boolean
  end

  def self.down
    remove_column :users, :continue_membership
  end
end
