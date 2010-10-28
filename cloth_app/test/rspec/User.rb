class User
  has_many :packages

  def is_registered?
    true
  end
  
end