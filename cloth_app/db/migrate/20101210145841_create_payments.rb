class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |p|
      p.integer :user_id
      p.integer :package_id
      p.integer :order_id
      p.boolean :kind

      p.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
