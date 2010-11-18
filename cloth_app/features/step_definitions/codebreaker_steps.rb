Given /^user signup$/ do
  
end

When /^user create his profile $/ do
  profile = Codebreaker::Profile.new(output)
  profile.create
end

Given /^user has no address$/ do
  
end

When /^user add his address$/ do
  address = Codebreaker::Address.new(output)
  address.add
end

Given /^user has no premium membership$/ do
  
end

When /^user upgrade his membership$/ do
  membership = Codebreaker::Membership.new(output)
  membership.upgrade
end

Given /^user has a membership$/ do
  
end

When /^user cancel his membership$/ do
  membership = Codebreaker::Membership.new(output)
  membership.cancel
end

When /^user delete his profile$/ do
  profile = Codebreaker::Profile.new(output)
  profile.delete
end


Given /^registered user has package$/ do
  
end

When /^user has set his holiday$/ do
  profile = Codebreaker::Profile.new(output)
  profile.set_holiday
end

When /^user create his profile$/ do
  profile = Codebreaker::Profile.new(output)
  profile.create
end

Then /^I should see "([^"]*)"$/ do |message|
  output.messages.should
  include(message)
end

class Output

  def messages
    @messages ||= []
  end

  def puts(messages)
    messages << message
  end

end

def output
  @output ||= Output.new
end