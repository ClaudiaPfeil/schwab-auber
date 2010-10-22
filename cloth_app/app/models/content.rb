class Content < ActiveRecord::Base
  belongs_to :category

  def destroyable?
    true
  end
  
end
