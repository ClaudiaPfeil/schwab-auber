class AddColumnCartonsToOptions < ActiveRecord::Migration
  def self.up
    add_column :options, :cartons, :integer
  end

  def self.down
    remove_column :options, :cartons
  end
end
