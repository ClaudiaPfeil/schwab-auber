# To change this template, choose Tools | Templates
# and open the template in the editor.

class Address < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :receiver, :street_and_number, :postcode, :town, :kind

  def is_destroyable?
    true
  end

  
end
