Feature: Administratin Dashboard
  As an applicatio administrator
  I need to have a place to keep track of important administration information
  So that I can maintain it

  Background: Administrator account is in place
    Given an admin was created with 'admin@travnoty.com' and 'adminpassword'

  Scenario: sign in
    Given I go to the 'admin' page
    And I fill in 'admin_email' with 'admin@travnoty.com'
    And I fill in 'admin_password' with 'adminpassword'
    When I press 'Sign in'
    Then I should see 'Signed in successfully.'

  Scenario: sign out
    Given I am on the 'admin' page
    And I am signed in
    When I click on 'Logout'
    Then I should see 'Signed out successfully.'
