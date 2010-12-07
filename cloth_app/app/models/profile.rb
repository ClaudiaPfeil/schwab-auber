# To change this template, choose Tools | Templates
# and open the template in the editor.

class Profile < ActiveRecord::Base
  has_one  :option
  has_one  :user
  has_many :addresses

  accepts_nested_attributes_for :user, :option, :addresses, :allow_destroy => true
  attr_accessor :friends_first_name, :friends_last_name, :friends_email

  SearchTypes = %w(name evaluation)
  
end
