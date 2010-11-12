class Package < ActiveRecord::Base
  
  belongs_to :user

  validates_presence_of :saison, :kind, :amount_clothes, :label, :amount_labels, :colors
  validates_numericality_of :accepted, :confirmed, :equal_to => 1
  validates_numericality_of :amount_clothes, :greater_than => 9

  attr_accessor :accepted, :confirmed
  accepts_nested_attributes_for :user, :allow_destroy => true

  scope :default_ordered, order('created_at DESC, size DESC')

  scope :search_by_attributes, lambda { |search_key, *attribute_names|
    sql = [attribute_names].flatten.map { |a| '%s LIKE :search_key' % a }.join(' OR ')
    where(sql, :search_key => "%#{search_key}%").default_ordered
  }

  before_save do
    set_serial_number
  end

  SearchTypes  = %w(name sex size label)

  def destroyable?
    true
  end

  def has_user?
    true unless self.user.nil?
  end

  private

    def set_serial_number
      self.serial_number = CPUtils::NumberGenerator.alphanumeric('kk', 6)
    end
  
end
