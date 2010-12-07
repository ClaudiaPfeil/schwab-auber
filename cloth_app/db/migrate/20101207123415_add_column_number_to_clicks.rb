class AddColumnNumberToClicks < ActiveRecord::Migration
  def self.up
    add_column  :clicks, :number, :integer
  end

  def self.down
    remove_column :clicks, :number
  end
end
