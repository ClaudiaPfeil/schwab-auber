# To change this template, choose Tools | Templates
# and open the template in the editor.
module Codebreaker

  class Membership

    def initialize(output)
      @output = output
    end

    def upgrade
      @output.puts = "You've upgraded your membership to premium"
    end

    def cancel
      @output.puts = "Your membership is canceled!"
    end
    
  end
  
end

