class AddShirtsBlousesJacketsJeansDressesBasicsToPackages < ActiveRecord::Migration
  def self.up
    add_column  :packages,  :shirts,  :string
    add_column  :packages,  :blouses, :string
    add_column  :packages,  :jackets, :string
    add_column  :packages,  :jeans,   :string
    add_column  :packages,  :dresses, :string
    add_column  :packages,  :basics,  :string
  end

  def self.down
    remove_column :packages,  :shirts
    remove_column :packages,  :blouses
    remove_column :packages,  :jackets
    remvoe_column :packages,  :jeans
    remove_column :packages,  :dresses
    remove_column :packages,  :basics
  end
end
