class UpdateSexInPackages < ActiveRecord::Migration
  def self.up
    change_column :packages, :sex, :boolean
  end

  def self.down
    change_column :packages, :sex, :string
  end
end
