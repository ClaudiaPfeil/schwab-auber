Feature: codebreaker get profiles

As an registered user I can crud my profile and edit settings like upgrade to premium account, edit holidays, crud my address, private data and last but not least cancel membership

Scenario: create profile
  Given user signup
  When  user create his profile
  Then  I should see "Your profile is created"

Scenario: update profile
  Given user has no address
  When  user add his address
  Then  I should see "Your profile is updated"

Scenario: upgrade his membership
  Given user has no premium membership
  When  user upgrade his membership
  Then  I should see "You've upgraded your membership to premium"

Scenario: cancel is membership
  Given user has a membership
  When  user delete his profile
  Then  I should see "You have canceled your membership"

Scenario: absence for holiday
  Given registered user has package
  When  user has set his holiday
  Then  I should see "User is in holiday, you can't order his package"

