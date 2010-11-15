class Order < ActiveRecord::Base
  belongs_to :user
  belongs_to :package
  
  #validates_uniqueness_of :order_number, :bill_number, :package_number, :package_id
  #validates_presence_of :package_id, :user_id

  before_save do
    create_order_number
    create_bill_number
    create_package_number if package_number.blank? || package_number.nil?
  end

  after_save do
    update_state_of_package
  end

  accepts_nested_attributes_for :user, :package, :allow_destroy => true
  
  def is_destroyable?
    true
  end

  # jeder, der ein Paket eingestellt hat, darf ein Paket bestellen
  def check_change_principle
    user_has_packages? ? true : false
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

    def user_has_packages?
      self.user.packages.count > Order.where(:user_id => self.user_id).count ? true : false
    end

    def update_state_of_package
      self.package.update_attribute(:state, 1)
    end

  
end
