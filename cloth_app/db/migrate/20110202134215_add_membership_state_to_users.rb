class AddMembershipStateToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :membership_state, :integer, :default => 0
  end

  def self.down
    remove_column :users, :membership_state
  end
end
