Feature: Account Settings
  In order to manage his travian accounts, client tokens, email, username and other settings
  A user, must be able to access his account settings

  Background:
    Given I am signed up as "johndoe@example.com"
    And my username is "JohnDoe"
    And I'm signed in

  Scenario:
    When I click on "JohnDoe"
    Then I should see "Change email"
