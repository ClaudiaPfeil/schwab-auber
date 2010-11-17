class CreateOrderBillNumbers < ActiveRecord::Migration
  def self.up
    create_table :order_bill_numbers do |o|
      o.integer :number

      o.timestamps
    end
  end

  def self.down
    drop_table :order_bill_numbers
  end
end
