Feature: Update servers
  In order to manage user's Travian accounts
  As a Travnoty developer I need to keep the list of running servers updated
  So that no user starts receives notifications from another round's account

  Background:
    Given the following hubs exist
      | code | name          | host            | language | main_hub |
      | de   | Germany       | www.travian.de  | de       |          |
      | net  | Spain         | www.travian.com | es       |          |
      | pt   | Portugal      | www.travian.pt  | pt       |          |
    And the following servers exist
      | hub | code | host             | name        | world id | speed | start_date |
      | de  | ts7  | ts7.travian.de   | Welt 7      | de77     | 1     | 22-07-2012 |
      | de  | tcx8 | tcx8.travian.de  | Speed 8x    |          | 8     | 11-12-2012 |
      | net | ts10 | ts10.travian.net | Servidor 10 | neta10   | 1     | 24-01-2013 |
      | pt  | ts7  | ts7.travian.pt   | Servidor 7  | pt77     | 1     | 16-11-2012 |
    And they are already loaded in the database

  @time_dependent
  Scenario: Servers ended
    Given today is 18-02-2013
    And the following servers no longer exist
      | hub | code |
      | de  | ts7  |
      | net | ts10 |
    When I run the task `rake travian:update`
    Then I should still have 4 servers
    But I should now have only 2 running rounds
    And I should have 2 ended rounds

  @time_dependent
  Scenario: New servers starting
    Given today is 18-02-2013
    And the following new servers were announced
      | hub | code | host            | name     | world id | speed | start_date |
      | de  | tx3  | tx3.travian.de  | Speed 3x | dex18    | 1     | 22-02-2013 |
      | net | tx3  | tx3.travian.com | Speed 3x | comx18   | 1     | 25-02-2013 |
      | pt  | tx3  | tx3.travian.pt  | Speed 3x | ptx18    | 1     | 22-02-2013 |
    When I run the task `rake travian:update`
    Then I should have 3 restarting servers
