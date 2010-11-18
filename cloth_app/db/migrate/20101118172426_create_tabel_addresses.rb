class CreateTabelAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |a|
      a.integer :user_id
      a.string  :receiver
      a.string  :receiver_additonal
      a.string  :street_and_number
      a.string  :postcode
      a.string  :town
      a.string  :land

      a.timestamps
    end
  end

  def self.down
    drop_table :addresses
  end
end
