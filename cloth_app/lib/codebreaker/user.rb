# To change this template, choose Tools | Templates
# and open the template in the editor.
module Codebreaker
  
  class User
    
    def initialize(output)
      @output = output
    end

    def create
      @output.puts = 'Your account is created'
    end

    def advert_friend
      @output.puts = 'E-Mail invitation'
    end

    def click_landingpage
      @output.puts = 'Welcome to KidsKarton.de'
    end

    def lead_account
      @output.puts = 'Sign-up to KidsKarton.de'
    end

    def show_tracking
      @output.puts = 'Trackings'
    end
    
  end

end

