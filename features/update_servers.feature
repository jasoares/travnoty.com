Feature: Update Servers
  In order to always have an updated list of the existent Travian servers
  As the application admin I need to periodically run a task to check
  if new servers exist and to add them to the database and to check which
  servers ended and to add that information to the database

  @slow
  Scenario:
    Given I have the hub pt in the database with 2 servers
    Given there are now 8 pt servers online
    When I run the task `rake update:servers[pt]`
    Then I should have 8 servers in the pt hub

  @slow
  Scenario:
    Given I have 10 servers in the database for the pt hub
    Given there are now 8 pt servers online
    When I run the task `rake update:servers[pt]`
    Then I should have 10 servers in the pt hub
    And I should have 2 servers in the pt hub with an end date