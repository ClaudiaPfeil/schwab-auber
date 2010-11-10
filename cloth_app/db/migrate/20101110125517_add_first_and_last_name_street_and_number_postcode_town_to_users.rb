class AddFirstAndLastNameStreetAndNumberPostcodeTownToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :street_and_number, :string
    add_column :users, :postcode, :string
    add_column :users, :town, :string
  end

  def self.down
    remove_column :users, :first_name
    remove_column :users, :last_name
    remove_column :users, :street_and_number
    remove_column :users, :postcode
    remove_column :users, :town
  end
end
