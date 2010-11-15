class Order < ActiveRecord::Base
  belongs_to :user
  belongs_to :package
  
  validates_uniqueness_of :order_number, :bill_number, :package_number, :package_id, :on => {:save, :update}, :scope => :user_id
  validates_presence_of :package_id, :user_id, :change_principle, :package_number, :on => {:save, :update}
  validates_numericality_of :change_principle, :equal_to => 1, :message => I18n.t(:equal_change_principle), :on => :save

  before_save do
    create_order_number
    create_bill_number
    create_package_number if package_number.blank? || package_number.nil?
    check_change_principle
    package_available?
  end

  after_save do
    update_state_of_package
  end

  accepts_nested_attributes_for :user, :package, :allow_destroy => true
  attr_accessor :change_principle
  
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

    def check_change_principle
      # jeder, der ein Paket eingestellt hat, darf ein Paket bestellen
      user_has_packages? ? self.change_principle = 1 : self.change_principle = 0
    end

    def user_has_packages?
      self.user.packages.count > 0 ? true : false
    end

    def package_available?
      self.package.state == 0 ? true : false
    end

    def update_state_of_package
      self.package.update_attribute(:state, 1)
    end

  
end
