class Login < ActiveRecord::Base
  has_one :customer

  accepts_nested_attributes_for :customer, :allow_destroy => true

  def destroyable?
    false
  end
end
