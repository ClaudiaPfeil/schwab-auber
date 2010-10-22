class AddColumnCategoryIdToContents < ActiveRecord::Migration
  def self.up
    add_column :contents, :category_id, :integer
  end

  def self.down
    remove_column :contents, :category_id, :integer
  end
end
