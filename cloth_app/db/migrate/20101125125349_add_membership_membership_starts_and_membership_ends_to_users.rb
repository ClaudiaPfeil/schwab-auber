class AddMembershipMembershipStartsAndMembershipEndsToUsers < ActiveRecord::Migration
  def self.up
    add_column  :users, :membership,  :boolean, :default => 0
    add_column  :users, :membership_starts, :date
    add_column  :users, :membership_ends, :date
  end

  def self.down
    remove_column :users, :membership
    remove_column :users, :membership_starts
    remove_column :users, :membership_ends
  end
end
