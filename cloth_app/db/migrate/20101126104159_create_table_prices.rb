class CreateTablePrices < ActiveRecord::Migration
  def self.up
    create_table  :prices do |price|
      price.integer :membership,  :default  =>  0.00
      price.integer :shipping,  :default => 11.00
      price.integer :handling,  :default => 1.20
      price.boolean :kind

      price.timestamps
    end
  end

  def self.down
    drop_table :prices
  end
end
