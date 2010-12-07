class CreateTableLeads < ActiveRecord::Migration
  def self.up
    create_table  :leads  do |l|
      l.integer :user_id
      l.string  :cookie_key
      l.string  :remote_ip
      l.integer :new_user_id

      l.timestamps
    end
  end

  def self.down
    drop_table :leads
  end
end
