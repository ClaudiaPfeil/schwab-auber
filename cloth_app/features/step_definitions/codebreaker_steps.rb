##############################################
# Profiles
##############################################
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

##############################
#Users
##############################
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

###############################################
# Payment
##############################################
Given /^user order$/ do

end

Given /^user profile$/ do

end

Given /^payment receipt$/ do

end

Given /^user has no payment receipt$/ do

end

Given /^users open payments$/ do

end

Given /^premium user$/ do

end

When /^user choosed payment via prepayment$/ do
  payment  =  Codebreaker::Payment.new(output)
  payment.prepayment(output)
end

When /^choose payment via paypal$/ do
  payment  =  Codebreaker::Payment.new(output)
  payment.paypal(output)
end

When /^user chooes payment via master-visa-card$/ do
  payment  =  Codebreaker::Payment.new(output)
  payment.master_visa_card(output)
end

When /^user write email$/ do
  payment  =  Codebreaker::Payment.new(output)
  payment.write_email(output)
end

When /^admin confirmed$/ do
  payment  =  Codebreaker::Payment.new(output)
  payment.admin_confirms(output)
end

When /^confirmation of payment receipt is older than 5 days$/ do
  payment  =  Codebreaker::Payment.new(output)
  payment.remember_payment(output)
end

When /^no payment receipts$/ do
  payment  =  Codebreaker::Payment.new(output)
  payment.payment_receipt(output)
end

When /^user confirms prepayment$/ do
  payment  =  Codebreaker::Payment.new(output)
  payment.premium_confirms_prepayment(output)
end

When /^cancel membership$/ do
  payment  =  Codebreaker::Payment.new(output)
  payment.premium_cancel_membership(output)
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