class Order < ActiveRecord::Base
  belongs_to :user
  belongs_to :package

  validates_uniqueness_of :order_number, :bill_number, :on => :save

  before_save do
    create_order_number
    create_bill_number
  end

  def is_destroyable?
    false
  end

  protected

    def create_order_number
      self.order_number = NumberGenerator.timebased
    end

    def create_bill_number
      self.bill_number = NumberGenerator.timebased
    end
  
end
