class CreateTableSettings < ActiveRecord::Migration
  def self.up
    create_table :settings do |s|
      s.boolean  :sex
      s.boolean  :name
      s.boolean  :first_name
      s.boolean  :last_name
      s.boolean  :address
      s.boolean  :first_letter_of_first_name
      s.boolean  :first_letter_of_last_name
      s.boolean  :date_of_birth
      s.boolean  :telephone

      s.timestamps
    end
  end

  def self.down
    drop_table :settings
  end
end
