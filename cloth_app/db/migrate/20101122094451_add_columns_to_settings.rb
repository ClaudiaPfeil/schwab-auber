class AddColumnsToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :first_letter_of_first_name, :boolean
    add_column :settings, :first_letter_of_last_name, :boolean
    add_column :settings, :first_name, :boolean
  end

  def self.down
    remove_column :settings, :first_letter_of_first_name
    remove_column :settings, :first_letter_of_last_name
    remove_column :settings, :first_name
  end
end
