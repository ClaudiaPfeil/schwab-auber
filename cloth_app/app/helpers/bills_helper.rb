module BillsHelper

  def formatted_date(date)
    date.strftime("%d.%m.%Y") unless date.nil?
  end

  def get_address
    addresses = @bill.user.addresses
    
    if addresses && addresses.count > 1

      addresses.each do |a|

        if a.first.kind == true
          return a.first
        end
        
      end

    elsif addresses && addresses.count == 1
      return addresses.first
    else
      nil
    end  
  end
  
end
