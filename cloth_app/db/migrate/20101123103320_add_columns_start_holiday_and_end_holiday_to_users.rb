class AddColumnsStartHolidayAndEndHolidayToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :start_holidays, :date
    add_column  :users, :end_holidays, :date
  end

  def self.down
    remove_column :users, :start_holidays
    remove_column :users, :end_holidays
  end
end
