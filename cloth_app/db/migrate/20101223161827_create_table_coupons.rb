class CreateTableCoupons < ActiveRecord::Migration
  def self.up
    create_table :coupons do |c|
      c.string :code
      c.boolean :used, :default => 0

      c.timestamps
    end
  end

  def self.down
    drop_table :coupons
  end
end
