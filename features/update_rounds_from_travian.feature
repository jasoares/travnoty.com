Feature: Update rounds from Travian
  In order to manage user's Travian accounts
  As a Travnoty developer I need to keep the list of server rounds updated
  So that no user starts receives notifications from another round's account

  Scenario: Adding a restarting round to a server with no rounds
    Given I have a server with no rounds
    When the update process tries to add a restarting round
    Then I should end up with 1 round

  Scenario: Adding a running round to a server with ended rounds
    Given I have a server with the following rounds
      | start_date | end_date   |
      | 01-03-2010 | 12-01-2011 |
      | 08-02-2011 | 25-01-2012 |
    When the update process tries to add the following round
      | start_date | end_date   |
      | 26-01-2012 | nil        |
    Then I should end up with 3 rounds

  Scenario: Adding a round before other ends
    Given I have a server with the following rounds
      | start_date | end_date   |
      | 08-02-2011 | 25-01-2012 |
      | 04-03-2012 | nil        |
    When the update process tries to add a new round
    Then it should rollback

  Scenario: Adding round with start date before the end date of another
    Given I have a server with the following rounds
      | start_date | end_date   |
      | 08-02-2011 | 25-01-2012 |
    When the update process tries to add the following round
      | start_date | end_date   |
      | 04-01-2012 | nil        |
    Then it should rollback
