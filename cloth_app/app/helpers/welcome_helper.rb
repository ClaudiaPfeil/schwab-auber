# To change this template, choose Tools | Templates
# and open the template in the editor.

module WelcomeHelper

  def get_all_cartons_orders
    User.where(:ordered_cartons => 1).to_a if current_user.is? :admin
  end
  
end
