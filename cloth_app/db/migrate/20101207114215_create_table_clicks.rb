class CreateTableClicks < ActiveRecord::Migration
  def self.up
    create_table :clicks do |c|
      c.integer :user_id
      c.string  :clicker_key
      c.string  :cookie_key
      c.string  :remote_ip
      c.date    :cookie_expires_at
      
      c.timestamps
    end
  end

  def self.down
    drop_table :clicks
  end
end
