class Category < ActiveRecord::Base
  has_many :contents

  def destroyable?
    false
  end
  
end
