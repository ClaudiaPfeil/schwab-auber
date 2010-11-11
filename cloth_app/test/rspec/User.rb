class User
  has_many :packages
  has_many :orders

  def is_registered?
    true
  end
  
end