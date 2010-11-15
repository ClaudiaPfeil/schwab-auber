class Order < ActiveRecord::Base
  belongs_to :user
  belongs_to :package

  validates_uniqueness_of :order_number, :bill_number, :package_id, :on => :save
  validates_presence_of :package_id, :user_id, :on => {:save, :update}

  before_save do
    create_order_number
    create_bill_number
    create_package_number if package_number.nil? 
  end

  accepts_nested_attributes_for :user, :package, :allow_destroy => true
  attr_accessor :package_namber
  
  def is_destroyable?
    true
  end

  protected

    def create_order_number
      self.order_number = NumberGenerator.timebased
    end

    def create_bill_number
      self.bill_number = NumberGenerator.timebased
    end

    def create_package_number
      self.package_number = NumberGenerator.alphanumeric({:prefix => "kk-", :length => 8})
    end
  
end
