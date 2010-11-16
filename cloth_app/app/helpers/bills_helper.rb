module BillsHelper

  def formatted_date(date)
    date.strftime("%d.%m.%Y") unless date.nil?
  end
  
end
