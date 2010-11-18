# To change this template, choose Tools | Templates
# and open the template in the editor.

class Address < ActiveRecord::Base
  belongs_to :user

  def is_destroyable?
    true
  end

  
end
