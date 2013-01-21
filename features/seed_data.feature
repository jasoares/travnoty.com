Feature: Seed Data
  In order to deploy the application so that it can start serving clients
  I need to seed the database with data from Travian hubs and servers

  @slow
  Scenario:
    Given I have no hubs
    And I have no servers
    When I run the task `rake db:seed`
    Then I should have loaded the hubs
    And I should have loaded the servers
    And I should have loaded the rounds
