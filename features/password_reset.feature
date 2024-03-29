Feature: Password Reset
  In order to sign in, in the case a user ever forgets his password
  A user must be able to reset it

  Background:
    Given I signed up with "email@example.com"
    When I go to the request password reset page
    And I fill in "Email" with "email@example.com"
    And I press "Reset password"
    Then an email with reset instructions should be sent to "email@example.com"

  Scenario: User resets his password successfully
    When I follow the password reset link sent in the email
    And I fill in "New Password" with "newpassword"
    And I fill in "Password confirmation" with "newpassword"
    And I press "Change password"
    Then I should see "Password has been reset"
    Then I should be signed in

  Scenario: User resets his password successfully and tries to use link again
    Given I just reset my password successfully
    When I follow the password reset link sent in the email again
    Then I should see "The reset password token is invalid or has expired. Please request a new one"
    And I should be on the request password reset page

  Scenario: User tries to reset password after token expired
    Given the token has expired
    When I follow the password reset link sent in the email
    Then I should see "The reset password token is invalid or has expired. Please request a new one"
    And I should be on the request password reset page
