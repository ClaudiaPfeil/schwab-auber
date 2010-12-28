# To change this template, choose Tools | Templates
# and open the template in the editor.

module WelcomeHelper

  def get_all_cartons_orders
    User.where(:ordered_cartons => 1).to_a if current_user.is? :admin
  end

  def get_best_evaluated_orders
    Order.where(:evaluation => "very_good") if current_user.is? :admin
  end

  def get_most_send_packages
   users = User.find(:all, :joins => "INNER JOIN packages on packages.user_id = users.id and packages.state = 1").group_by { |user|  user.packages.count } if current_user.is? :admin
   if users
     sorted_hash = {}
     sort = users.to_a.reverse
     
     sort.each do |s|
       sorted_hash[s[0]] = users.fetch(s[0]).first
     end
     
     return sorted_hash
   end
  end

  def get_label_packages
    packages = Package.all.group_by { |package| package.amount_labels } if current_user.is? :admin

    if packages
     sorted_hash = {}
     sort = packages.to_a.reverse

     sort.each do |s|
       sorted_hash[s[0]] = packages.fetch(s[0]).first
     end
     #sorted_hash["amount"] = users.first[0]
     return sorted_hash
    end
    
  end

  def get_charity_donation
    sells = Payment.find_by_sql("Select * from payments where left(created_at, 7) like '%#{Date.today.to_s.chop.chop.chop}%'" )
    amount = sells.count
    
    (amount.to_f * 0.25).to_s + " €"
  end
  
end
