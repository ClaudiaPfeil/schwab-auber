class UpdateTableAddresses < ActiveRecord::Migration
  def self.up
    rename_column :addresses, :receiver_additonal, :receiver_additional
  end

  def self.down
    rename_column :addresses, :receiver_additional, :receiver_additonal
  end
end
