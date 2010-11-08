class Package < ActiveRecord::Base
  
  belongs_to :user

  validates_presence_of :saison, :kind, :amount_clothes, :label, :amount_labels, :colors
  
#  before_save do
#    enough_clothes?
#    has_accepted_rules?
#    has_confirmed?
#  end
  
  attr_accessor :accepted, :confirmed
  accepts_nested_attributes_for :user, :allow_destroy => true

  scope :default_ordered, order('created_at DESC, size DESC')

  scope :search_by_attributes, lambda { |search_key, *attribute_names|
    sql = [attribute_names].flatten.map { |a| '%s LIKE :search_key' % a }.join(' OR ')
    where(sql, :search_key => "%#{search_key}%").default_ordered
  }

  SearchTypes  = %w(name sex size label)

  def destroyable?
    true
  end

  def has_user?
    true unless self.user.nil?
  end

  private

    def confirmed?
      true if confirmed == true
    end

    def accepted?
      true if accepted == true
    end

    def enough_clothes?
      true if amount_clothes.to_i > 9
    end
  
end
