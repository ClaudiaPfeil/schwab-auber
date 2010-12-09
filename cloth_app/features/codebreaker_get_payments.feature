Feature:  codebreaker get payments

As an user I want to pay my cloth packages via prepayment
As an user I want to pay my cloth packages via paypal
As an user I want to pay my cloth packages via Master/Visa-Card
As an user I want to check my bank balance
As an admin I want to confirm the payment receipt
As an admin I want to be informed by email if confirmation of the payment receipt is older than 5 days
As an admin I want to get an list with all left payment receipts
As an admin I want to be informed by the user if he has payed his premium membership
As an admin I want to be informed by the system if a premium user has canceled his membership

Scenario: pay via prepayment
Given user order
When user choosed payment via prepayment
Then I should see "Prepayment"

Scenario: pay via paypal
Given user order
When choose payment via paypal
Then I should see "Paypal"

Scenario: pay via master/visa-card
Given user order
When user chooes payment via master-visa-card
Then I should see "Master/Visa- Card"

Scenario: check bank balance
Given user profile
When user write email
Then I should see "Check bank balance"

Scenario: confirm the payment receipt
Given payment receipt
When admin confirmed
Then I should see "Admin confirmed payment receipt"

Scenario: inform by email
Given user has no payment receipt
When confirmation of payment receipt is older than 5 days
Then I should see "Remember payment"

Scenario: get a list
Given users open payments
When no payment receipts
Then I should see "Admin can export list"

Scenario: inform admin when premium has payed with prepayment
Given premium user
When user confirms prepayment
Then I should see "Premium user has payed membership"

Scenario: inform admin if premium cancel membership
Given premium user
When cancel membership
Then I should see "Admin is informed by email"