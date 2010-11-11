class Package < ActiveRecord::Base
  belongs_to :user
  has_one :order

  validates_presence_of :saison, :kind, :amount_clothes, :label, :amount_labels, :colors, :accepted, :confirmed
  before_save do
    confirmed?
    accepted?
    enough_clothes?
  end

  attr_accessor :previewed, :confirmed, :accepted

  scope :size => lambda  { |search_key|
                           where(' order_status = :order_status
                                   OR oldarticle_status = :oldarticle_status
                                   OR newarticle_status = :newarticle_status',
                           search_key )
                          }
  scope :sex
  scope :saison

  def has_user?
    true
  end

  private

    def confirmed?
      true if previewed == true
    end

    def accepted?
      true
    end

    def enough_clothes?
      true if amount_clothes >= 10
    end
  
end
