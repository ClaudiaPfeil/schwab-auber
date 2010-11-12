class CreateTableOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |order|
      order.string  :order_number
      order.string  :package_number
      order.integer :user_id
      order.integer :package_id
      order.integer :evaluation
      order.text    :eva_notice
      order.date    :eva_date_created_at
      order.date    :eva_date_updated_at
      order.text    :notice
      
      order.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end
