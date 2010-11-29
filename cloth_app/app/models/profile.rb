# To change this template, choose Tools | Templates
# and open the template in the editor.

class Profile < ActiveRecord::Base
  has_one  :option
  has_one  :user
  has_many :addresses

  accepts_nested_attributes_for :user, :option, :addresses, :allow_destroy => true
  #attr_accessible :option_attributes

  SearchTypes = %w(name evaluation)

  def cartons
    self.user.cartons
  end
  
end
