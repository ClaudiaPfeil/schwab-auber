require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  include Authorization::StatefulRoles
  include Cms
  set_table_name 'users'
  
  has_many :packages
  has_many :orders
  has_many :addresses
  has_one  :option
  has_one  :bank_detail
  has_many :payments

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

  validates_numericality_of :accepted, :equal_to => 1, :on => :create, :message => :agbs_not_accepted

  #validates_presence_of :street_and_number, :postcode, :town,  :land, :message => "Lieferanschrift muss angegeben werden."


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
  attr_accessible :login, :email, :name, :password, :password_confirmation, :role, :activated_at, :user_number, :updated_at, :sex, :last_name, :telephone, :date_of_birth, 
                  :first_name, :option_attributes, :start_holidays, :end_holidays, :cartons, :membership, :membership_starts, :membership_ends,  :premium_period, :continue_membership, :accepted, :address, :street_and_number, :postcode, :town, :land, :kind, :tag_names
  attr_accessor   :password_confirmation, :friends_first_name, :friends_last_name, :friends_email, :accepted, :address, :street_and_number, :postcode, :town, :land, :kind, :tag_names
  accepts_nested_attributes_for :addresses, :option, :bank_detail

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
    self.update_attribute(:cartons, (self.cartons.to_i - 1))
  end

  def count_up
    self.update_attribute(:cartons, (self.cartons.to_i + 1))
  end

  def calc_score
    evas = Order.find(:all, :joins => :package, :conditions => { :packages => { :user_id => self.id }})

    number_evas = evas.count
    max = 0

    if number_evas > 1
      evas.each do |e|
        return  do_eva(e, max) unless e.evaluation.blank?
      end
      
    elsif number_evas == 1
      return do_eva(evas, max) unless evas.evaluation.blank?
    end
    
  end

  def premium_is_destroyable?
    self.membership_ends < Date.today ? true : false
  end

  def destroy_premiums
    premiums = self.where(:membership => 1, :membership_ends => Date.today, :canceled => 1 )
    premiums.each do |prem|
      packages = prem.packages
      packages.each do |package|
        package.destroy
      end
      prem.destroy
    end
  end

  def get_agbs
    get_content("Agbs")
  end

  def has_delivery_address?
    addresses = self.addresses
  
    if addresses.count > 1
      addresses.each do |address|
        address.kind == false ? true : false
      end
    elsif addresses.blank?
      false
    else
      addresses.first.kind == 0 ? true : false
    end
  end

  def has_bill_address?
    addresses = self.addresses
    if addresses.count > 1
      addresses.each do |address|
        address.kind == true ? true : false
      end
    elsif addresses.blank?
      false
    else
      addresses.first.kind == 1 ? true : false
    end
  end

  def is_owner?(package)
    compare = ""
    packages.each do |pack|
      compare << pack.id.to_s
    end
    compare.include?(package.id.to_s) ? true : false unless package.nil?
  end
  
  protected
    
    def make_activation_code
          self.deleted_at = nil
          self.activation_code = self.class.make_token
    end

    def set_user_number
      self.user_number.nil? ? self.user_number = NumberGenerator.alphanumeric({:prefix => "KK-", :length => 9}) : self.user_number = self.user_number
    end

    def do_eva(e, max)
      result = {
        :very_good => 0,
        :good  => 0,
        :ok  => 0,
        :bad => 0,
        :very_bad => 0
      }
      
      max += 1
      case e.evaluation.to_s
        when "5"
          result[:very_good] += 5
        when "4"
          result[:good] += 4
        when "3"
          result[:ok] += 3
        when "2"
          result[:bad] += 2
        when "1"
          result[:very_bad] += 1
      end

      max_eva = result[:very_good] + result[:good] + result[:ok] + result[:bad] + result[:very_bad]
      logger.info("max_eva=" + max_eva.to_s)
      score = ((max_eva.to_i / (5 * max.to_i)) * 100 ).to_s + "%"
      logger.info("score=" + score.to_s)
      return (max * 5), max_eva, score
    end
end
