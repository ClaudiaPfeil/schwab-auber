class OrderBillNumber < ActiveRecord::Base

 Offset = 10000

 def self.create_number
   new_number = create
   new_number.update_attribute(:number, new_number.id + Offset)
   new_number.number
 end

end
