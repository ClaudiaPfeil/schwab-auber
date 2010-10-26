class AddLinkNameToContents < ActiveRecord::Migration
  def self.up
    add_column :contents, :link_name, :string
  end

  def self.down
    remove_column :contents, :link_name
  end
end
