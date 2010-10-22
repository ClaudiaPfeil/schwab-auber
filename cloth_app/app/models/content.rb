class Content < ActiveRecord::Base
  has_attached_file :image
  validates_attachment_presence :image
  belongs_to :category
 
  accepts_nested_attributes_for :category, :allow_destroy => false

  def destroyable?
    true
  end
  
end
