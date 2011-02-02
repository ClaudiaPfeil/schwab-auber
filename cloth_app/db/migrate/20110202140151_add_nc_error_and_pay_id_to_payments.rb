class AddNcErrorAndPayIdToPayments < ActiveRecord::Migration
  def self.up
    add_column :payments, :pay_id, :string
    add_column :payments, :nc_error, :string
  end

  def self.down
    remove_column :payments, :pay_id
    remove_column :payments, :nc_error
  end
end
