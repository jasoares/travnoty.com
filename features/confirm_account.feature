Feature: Confirm Account
  In order to make sure the notifications are sent to the account owners email
  A user must be able to confirm her email address

  Background:
    Given I signed up with "email@example.com"
    Then an email with confirmation instructions should be sent to "email@example.com"

  Scenario: User confirms her email successfully
    When I follow the confirmation link sent in the email
    Then I should be on the profile page
    And I should see "Your email has been verified."
    And I should be signed in

  Scenario: User follows a confirmation email link that was already used
    Given the email is already confirmed
    When I follow the confirmation link sent in the email
    Then I should see "Your email was already verified."
