class AddKindToAddresses < ActiveRecord::Migration
  def self.up
    add_column :addresses, :kind, :tinyint
  end

  def self.down
    remove_column :addresses, :kind
  end
end
