class Category < ActiveRecord::Base
  has_many :contents

  accepts_nested_attributes_for :contents

  def destroyable?
    false
  end
  
end
