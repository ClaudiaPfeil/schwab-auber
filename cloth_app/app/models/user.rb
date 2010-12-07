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
  has_one  :option

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
  attr_accessible :login, :email, :name, :password, :password_confirmation, :role, :activated_at, :user_number, :updated_at, :sex, :last_name, :telephone, :date_of_birth, :first_name, :option_attributes, :start_holidays, :end_holidays, :cartons, :membership, :membership_starts, :membership_ends,  :premium_period, :tag_names
  attr_accessor   :friends_first_name, :friends_last_name, :friends_email, :tag_names
  accepts_nested_attributes_for :addresses, :option

  # users roles
  scope :with_role, lambda { |role| {:conditions => "roles_mask & #{2**ROLES.index(role.to_s)} > 0 "} }
  ROLES = %w[admin publisher premium registered guest]

  SearchTypes = %w(name evaluation packages)

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
    first_name + " " + last_name unless first_name.nil? || last_name.nil?
  end

  def is_destroyable?
    true
  end

  def is_premium?
    self.membership == 1 ? true : false
  end

  def count_down
    self.update_attribute(:cartons, 4)
  end

  def calc_score(user_id)
    evas = self.orders.where(:user_id => user_id)
    result = {
      :very_good => 0,
      :good  => 0,
      :ok  => 0,
      :bad => 0,
      :very_bad => 0
    }

    number_evas = 0

    evas.each do |e|
      number_evas += 1
      case e.evaluation
      when  "very_good"
        result[:very_good] += 1
      when "good"
        result[:good] += 1
      when "ok"
        result[:ok] += 1
      when "bad"
        result[:bad] += 1
      when "very_bad"
        result[:very_bad] += 1
      else
        number_evas -= 1
      end
    end

    max = number_evas.to_i * 5
    very_good = result[:very_good] * 5
    good  = result[:good] * 4
    ok  = result[:ok] * 3
    bad = result[:ok] * 2
    very_bad = result[:very_bad] * 1

    max_eva = very_good + good + ok + bad + very_bad

    score = max_eva / 100 * max

    return score, max, max_eva
  end

  def premium_is_destroyable?
    self.membership_ends < Date.today ? true : false
  end

  protected
    
    def make_activation_code
          self.deleted_at = nil
          self.activation_code = self.class.make_token
    end

    def set_user_number
      self.user_number.nil? ? self.user_number = NumberGenerator.alphanumeric({:prefix => "KK-", :length => 9}) : self.user_number = self.user_number
    end

end
