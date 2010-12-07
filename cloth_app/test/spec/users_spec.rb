# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'codebreaker'

module Codebreaker

  describe "#send_invitation" do

    it "sends a confirmation message" do
      output = double('output')
      user = User.new(output)
      output.should_receive(:puts).with('Your invitation e-mail was send')
      user.create
    end

  end

  describe "#click_on_landingpage" do

    it "sets cookie" do
      output = double('output')
      user = User.new(output)
      output.should_receive(:puts).with('Users cookie was set')
      user.set_cookie
    end

  end

  describe "#lead_on_signup" do

    it "saved lead" do
      output = double('output')
      user = User.new(output)
      output.should_receive(:puts).with('Lead saved')
      user.set_lead
    end

  end

  describe "#show_leads" do

    it "shows users leads" do
      output = double('output')
      user = User.new(output)
      output.should_receive(:puts).with('Lead saved')
      user.show_leads
    end

  end
  
end



