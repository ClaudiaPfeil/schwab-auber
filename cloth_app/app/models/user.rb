require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  include Authorization::StatefulRoles
  set_table_name 'users'
  
  has_many :packages
  has_many :orders
  has_many :addresses
  has_one :setting

  validates :login, :presence   => true,
                    :uniqueness => true,
                    :length     => { :within => 3..40 },
                    :format     => { :with => Authentication.login_regex, :message => Authentication.bad_login_message }

  validates :name,  :format     => { :with => Authentication.name_regex, :message => Authentication.bad_name_message },
                    :length     => { :maximum => 100 },
                    :allow_nil  => true

  validates :email, :presence   => true,
                    :uniqueness => true,
                    :format     => { :with => Authentication.email_regex, :message => Authentication.bad_email_message },
                    :length     => { :within => 6..100 }

  validates_presence_of :first_name, :last_name

  scope :default_ordered, order('created_at DESC')

  scope :search_by_attributes, lambda { |search_key, *attribute_names|
    sql = [attribute_names].flatten.map { |a| '%s LIKE :search_key' % a }.join(' OR ')
    where(sql, :search_key => "%#{search_key}%").default_ordered
  }

  before_save do
    set_user_number if self.user_number.nil?
  end

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation, :role, :first_name, :last_name, :street_and_number, :postcode, :town

  # users roles
  scope :with_role, lambda { |role| {:conditions => "roles_mask & #{2**ROLES.index(role.to_s)} > 0 "} }
  ROLES = %w[admin publisher premium registered guest]

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find_in_state :first, :active, :conditions => {:login => login.downcase} # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.sum
  end

  def roles
    ROLES.reject do |r|
      ((roles || 0) & 2**ROLES.index(r)).zero?
    end
  end

  def is?(this_role)
    role.include?(this_role.to_s) unless role.nil?
  end

  def name
    last_name + ", " + first_name
  end

  def is_destroyable?
    true
  end

  protected
    
    def make_activation_code
          self.deleted_at = nil
          self.activation_code = self.class.make_token
    end

    def set_user_number
      self.user_number.nil? ? self.user_number = NumberGenerator.alphanumeric({:prefix => self.last_name.first.capitalize + self.first_name.first.capitalize  + "- ", :length => 6}) : self.user_number = self.user_number
    end

end
