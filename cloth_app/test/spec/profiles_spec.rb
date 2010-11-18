# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'codebreaker'

module Codebreaker

  describe "#create" do
    it "sends a confirmation message" do
      output = double('output')
      profile = Profile.new(output)
      output.should_receive(:puts).with('Your profile is created')
      profile.create
    end
  end

  describe "#delete" do
    it "sends a confirmation message" 
  end

  describe "#set_holiday" do
    it "sends a confirmation message"
  end
end



