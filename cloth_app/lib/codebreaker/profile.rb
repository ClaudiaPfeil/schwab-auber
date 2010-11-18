# To change this template, choose Tools | Templates
# and open the template in the editor.

module Codebreaker
  
  class Profile

    def initialize(output)
      @output = output
    end

    def create
      @output.puts = 'Your profile is created'
    end

    def upgrade
      @output.puts = 'Your membership is upgraded to premium!'
    end

    def delete
      membership = Codebreaker::Membership.new(output)
      membership.cancel
      @output.puts = 'You have canceled your membership'
    end

    def set_holiday
      @output.puts = "User is in holiday, you can't order his package"
    end
    
  end
    
end
