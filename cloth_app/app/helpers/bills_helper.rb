module BillsHelper

  def formatted_date(date)
    date.strftime("%d.%m.%Y") unless date.nil?
  end

  def get_address
    addresses = @bill.user.addresses
    if addresses && addresses.count > 1
      addresses.each do |a|
        if a.kind == true
          return a
        end
      end
    elsif addresses && addresses.count == 1
      if addresses.kind == true
       return addresses
      end
    else
      nil
    end
    
  end
  
end
