Feature: Sign up
  As a user
  In order to start receiving notifications from my travian accounts
  I want to be able to sign up with my email address
  So that I can configure the Travnoty client to use my account

  Scenario: User signs up with valid data
    When I go to the sign up page
    And I fill in "Full Name" with "John Doe"
    And I fill in "Email" with "email@example.com"
    And I fill in "Password" with "mysecretpassword"
    And I fill in "Password Confirmation" with "mysecretpassword"
    And I press "Sign up"
    Then I should be signed in
