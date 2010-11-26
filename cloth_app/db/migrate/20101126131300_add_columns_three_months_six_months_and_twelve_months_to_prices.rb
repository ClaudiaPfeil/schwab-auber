class AddColumnsThreeMonthsSixMonthsAndTwelveMonthsToPrices < ActiveRecord::Migration
  def self.up
    add_column  :prices,  :three_months,  :float, :default  =>  9.90
    add_column  :prices,  :six_months,  :float, :default  =>  15.90
    add_column  :prices,  :twelve_months, :float, :default  =>  29.90
  end

  def self.down
    remove_column :prices,  :three_months
    remove_column :prices,  :six_months
    remove_column :prices,  :twelve_months
  end
end
