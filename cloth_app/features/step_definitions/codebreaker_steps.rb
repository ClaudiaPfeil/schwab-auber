#Profiles
Given /^user signup$/ do
  
end

Given /^registered user has package$/ do

end

Given /^user has no address$/ do

end

Given /^user has no premium membership$/ do

end

Given /^user has a membership$/ do

end

When /^user create his profile $/ do
  profile = Codebreaker::Profile.new(output)
  profile.create
end

When /^user add his address$/ do
  address = Codebreaker::Address.new(output)
  address.add
end

When /^user upgrade his membership$/ do
  membership = Codebreaker::Membership.new(output)
  membership.upgrade
end

When /^user cancel his membership$/ do
  membership = Codebreaker::Membership.new(output)
  membership.cancel
end

When /^user delete his profile$/ do
  profile = Codebreaker::Profile.new(output)
  profile.delete
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

#Users
Given /^user invitation$/ do

end

Given /^user invitation link$/ do

end

Given /^user click on landingpage$/ do

end

Given /^created tracking$/ do

end

When /^user write email$/ do
  user  =  Codebreaker::User.new(output)
  user.advert_friend(output)
end

When /^user receives invitation email$/ do
  user  =  Codebreaker::User.new(output)
  user.click_landingpage(output)
end

When /^user clickes on invitation link$/ do
  user  =  Codebreaker::User.new(output)
  user.lead_account(output)
end

When /^created lead$/ do
  user  =  Codebreaker::User.new(output)
  user.show_tracking(output)
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