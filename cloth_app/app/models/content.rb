class Content < ActiveRecord::Base
  
  has_attached_file :image
  belongs_to :category

  accepts_nested_attributes_for :category

  def destroyable?
    true
  end

  def is_published?
    published
  end
  
end
