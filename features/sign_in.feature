Feature: Sign in
  As a user
  in order to access my account status in a protected section of the site
  I want to be able to sign in with the credentials I used to sign up.

  Background:
    Given I am signed up as "johndoe@example.com"
    And my username is "johndoe"

  Scenario: User signs in successfully with email and password
    When I go to the sign in page
    And I fill in "username_or_email" with "johndoe@example.com"
    And I fill in "Password" with "mysecretpassword"
    And I press "Sign in"
    Then I should be signed in

  Scenario: User signs in successfully with username and password
    When I go to the sign in page
    And I fill in "username_or_email" with "johndoe"
    And I fill in "Password" with "mysecretpassword"
    And I press "Sign in"
    Then I should be signed in
