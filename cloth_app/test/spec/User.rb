class User
  has_many :packages
  has_many :orders

  def is_registered?
    true
  end

  def set_cookie
    true
  end

  def set_lead
    true
  end

  def show_leads
    true
  end
  
end