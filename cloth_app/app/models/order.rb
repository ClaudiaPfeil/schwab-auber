class Order < ActiveRecord::Base
  include Cms
  
  belongs_to :user
  belongs_to :package
  has_one :payment
  
  validates_uniqueness_of :order_number, :bill_number, :scope => [:package_id]
  validates_presence_of :package_id, :user_id

  before_save do
    create_order_number if order_number.nil? || order_number.blank?
    create_bill_number  if bill_number.nil? || bill_number.blank?
    create_package_number if package_number.blank? || package_number.nil?
  end

  after_save do
    update_state_of_package
  end

  accepts_nested_attributes_for :user, :package, :payment, :allow_destroy => true

  def is_destroyable?
    true
  end

  # jeder, der ein Paket eingestellt hat, darf ein Paket bestellen
  def check_change_principle
    user_has_packages? || user_first_order? ? true : false
  end

  # ein Kleiderpaket darf während der Abwesenheit wegen Urlaub nicht bestellt werden
  # da es dann zu Verzögerungen bei der Lieferung kommen würde
  def check_holidays
    start    = self.package.user.start_holidays
    last_day = self.package.user.end_holidays

    unless start.nil? || last_day.nil?
      Date.today.between?(start, last_day) ? false : true
    else
      true
    end
    
  end

  def get_contents(category)
    get_content(category).first.article.split(" ") if get_content(category)
  end

  def get_order_number
    create_order_number
  end

  def get_bill_number
    create_bill_number
  end
  
  private

    def create_order_number
      self.order_number = NumberGenerator.timebased
    end

    def create_bill_number
      #Rechnungsnummern sind fortlaufend
      self.bill_number = '%s-%s' % [Date.today.strftime("%Y%m%d"), OrderBillNumber.create_number]
    end

    def create_package_number
      self.package_number = NumberGenerator.alphanumeric({:prefix => "kk-", :length => 8})
    end

    def user_has_packages?
      self.user.packages.count > Order.where(:user_id => self.user_id).count ? true : false  unless self.user.nil? 
    end

    def user_first_order?
      Order.where(:user_id => self.user_id).count < 1 ? true : false
    end

    def update_state_of_package
      self.package.state = 1
      self.package.save
    end

end
