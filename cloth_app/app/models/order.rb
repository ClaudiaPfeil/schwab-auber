class Order < ActiveRecord::Base
  include NumberGenerator
  belongs_to :user
  belongs_to :package

  before_save do
    create_order_number
    create_bill_number
    package.serial_number.blank? ? create_package_number : self.package_number = package.serial_number
  end

  def is_destroyable?
    false
  end

  protected

    def create_order_number
      self.order_number = NumberGenerator.timebased
    end

    def create_package_number
      self.package_number = NumberGenerator.timebased
    end

    def bill_number
      self.bill_number = CPUtils::NumberGenerator.timebased
    end
  
end
