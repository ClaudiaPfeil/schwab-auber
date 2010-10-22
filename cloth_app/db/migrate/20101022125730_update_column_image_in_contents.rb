class UpdateColumnImageInContents < ActiveRecord::Migration
  def self.up
    rename_column :contents, :image, :image_file_name
  end

  def self.down
    rename_column :contents, :image_file_name, :image
  end
end
