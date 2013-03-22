Feature: Account Settings
  In order to manage his travian accounts, client tokens, email, username and other settings
  A user, must be able to access and make changes to his account

  Background:
    Given I am signed up as "johndoe@example.com"
    And my username is "JohnDoe"
    And I'm signed in
    And I click on "JohnDoe"

  Scenario: User visits his account settings
    Then I should see "Account"
    And I should see "Profile"
    And I should see a blank "Name" field
    And I should see an "Email" field with "johndoe@example.com"
    And I should see "Password"

  Scenario: User changes his name
    Given I fill in "Name" with "John Doe"
    And I press "Update"
    Then I should see "Your profile information was updated"
    And I should see a "Name" field with "John Doe"

  Scenario: User changes his email
    Given I fill in "Email" with "janedoe@example.com"
    And I press "Update"
    Then I should see "An email was sent with verification instructions"
    And I should see an "Email" field with "janedoe@example.com"
    And I should see "Verify"

  Scenario: User requests a new password
    Given I click on "here."
    And I fill in "Email" with "johndoe@example.com"
    And I press "Reset password"
    Then I should see "An email was sent with password reset instructions"
    And I should be on the account settings page
