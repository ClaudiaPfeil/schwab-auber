# To change this template, choose Tools | Templates
# and open the template in the editor.

class Lead < ActiveRecord::Base

  def destroyable?
    false
  end
end
