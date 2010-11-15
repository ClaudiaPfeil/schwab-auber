module OrdersHelper

  def formatted_date_of_order(date)
    date.strftime("%d.%m.%Y") unless date.nil?
  end
  
end
