class Package < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :saison, :kind, :amount_clothes, :label, :amount_labels, :colors, :accepted, :confirmed
  before_filter :confirmed?, :action => [:create, :update]
  before_filter :accepted?, :action => [:create, :update]
  before_filter :enough_clothes?, :action => [:create, :update]

  attr_accessor :previewed

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
