# To change this template, choose Tools | Templates
# and open the template in the editor.

class Payment < ActiveRecord::Base
  belongs_to :user
  belongs_to :package
  belongs_to :order

  attr_accessor :email, :message

  def is_destroyable?
    false
  end
  
end
