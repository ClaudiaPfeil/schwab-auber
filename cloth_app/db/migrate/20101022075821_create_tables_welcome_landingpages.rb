class CreateTablesWelcomeLandingpages < ActiveRecord::Migration
  def self.up
    create_table :contents do |content|
      content.string  :title
      content.string  :subtitle
      content.text    :article
      content.string  :image
      content.string  :link
      
      content.timestamps
    end

    create_table :categories do |category|
      category.string :name
      category.text   :description

      category.timestamps
    end
  end

  def self.down
    drop_table :contents
    drop_table :categories
  end
end
