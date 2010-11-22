# To change this template, choose Tools | Templates
# and open the template in the editor.

class Profile < User
  belongs_to :setting
  belongs_to :user

  accepts_nested_attributes_for :user, :setting, :addresses, :allow_destroy => true

  def settings
    self.setting
  end

  
end
