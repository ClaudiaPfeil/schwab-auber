# To change this template, choose Tools | Templates
# and open the template in the editor.

class Profile < User

  has_many :settings

  accepts_nested_attributes_for :user, :settings, :addresses, :allow_destroy => true

  
end
