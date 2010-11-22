class RenameTableSettingsIntoOptions < ActiveRecord::Migration
  def self.up
    rename_table :settings, :options
  end

  def self.down
    rename_table :options, :settings
  end
end
