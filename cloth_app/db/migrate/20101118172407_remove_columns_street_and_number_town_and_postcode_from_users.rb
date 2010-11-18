class RemoveColumnsStreetAndNumberTownAndPostcodeFromUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :street_and_number
    remove_column :users, :postcode
    remove_column :users, :town
  end

  def self.down
    add_column :users, :street_and_number, :string
    add_column :users, :postcode, :string
    add_column :users, :town, :string
  end
end
