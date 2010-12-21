class AddColumnPaiedAndStatusToPayments < ActiveRecord::Migration
  def self.up
    add_column  :users, :paied, :date
    add_column  :users, :status, :integer
  end

  def self.down
    remove_column :users, :paied
    remove_column :users, :status
  end
end
