Feature: Pre subscribe
  In order to generate some buzz and let us know if there are many people interested
  in our application
  A user must be able to enter our pre subscribe page and leave us their email
  so we can contact her later when it is ready to use

  Scenario: User pre subscribes with valid data
    When I go to the pre subscribe page
    And I fill in "Name" with "John Doe"
    And I fill in "Email" with "email@example.com"
    And I press "Pre subscribe"
    Then an email with the pre subscription confirmation should be sent to "email@example.com"
    And I should be on the home page
    And I should see "Thank you for showing you care John Doe"
