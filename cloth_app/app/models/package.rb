class Package < ActiveRecord::Base
  include Cms
  
  belongs_to :user
  has_one :order
  has_one :payment

  validates_presence_of :saison, :kind, :amount_clothes, :colors
  validates_numericality_of :accepted, :confirmed, :equal_to => 1
  validates_uniqueness_of :serial_number

  attr_accessor :accepted, :confirmed, :tops, :t_shirts, :polo_shirts, :langarm_shirt, :fleece_shirt, :pullover
  attributes = Category.new.get_attr
  #attr_accessor attributes unless attributes.nil?

  
  accepts_nested_attributes_for :user, :allow_destroy => true

  scope :default_ordered, order('created_at DESC, size DESC')

  scope :search_by_attributes, lambda { |search_key, *attribute_names|
    sql = [attribute_names].flatten.map { |a| '%s LIKE :search_key' % a }.join(' OR ')
    where(sql, :search_key => "%#{ search_key }%").default_ordered
  }

  before_save do
    set_serial_number if self.serial_number.nil? || self.serial_number.blank?
    puts self.serial_number
  end

  SearchTypes  = %w(serial_number sex size label)
 
  
  def destroyable?
    true
  end

  def has_user?
    true unless self.user.nil?
  end

  def get_rules
    get_content("Package")
  end

  def get_contents(title)
    get_content(title).first.article.split(" ") if get_content(title)
  end

  private

    def set_serial_number
      self.order.nil? ? self.serial_number = NumberGenerator.alphanumeric({:prefix => "kk-", :length => 8}) : self.serial_number = self.order.package_number
    end
  
end
