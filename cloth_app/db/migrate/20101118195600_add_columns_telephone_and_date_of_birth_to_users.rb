class AddColumnsTelephoneAndDateOfBirthToUsers < ActiveRecord::Migration
  def self.up
    add_column  :users, :date_of_birth, :date
    add_column  :users, :telephone, :string
  end

  def self.down
    remove_column :users, :date_of_birth
    remove_column :users, :telephone
  end
end
