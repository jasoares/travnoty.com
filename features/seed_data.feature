Feature: Seed Data
  In order to deploy the application so that it can start serving clients
  As a travnoty.com developer
  I need to seed the database with data from Travian hubs and servers

  Scenario: Seed the database with initial data
    Given I have a clean database
    And the following hubs exist
      | code | name                 | host               | language | main_hub |
      | ae   | United Arab Emirates | www.travian.ae     | ar       |          |
      | cl   | Chile                | www.travian.cl     | es       |          |
      | com  | International        | www.travian.com    | en       |          |
      | kr   | South Korea          | www.travian.co.kr  | en       | com      |
      | de   | Germany              | www.travian.de     | de       |          |
      | mx   | Mexico               | www.travian.com.mx | es       | cl       |
      | pt   | Portugal             | www.travian.pt     | pt       |          |
      | tr   | Turkey               | www.travian.tr     | tr       |          |
    And the following servers exist
      | hub | code       | host                      | name        | world id | speed | start_date |
      | ae  | ts1        | ts1.travian.ae            | السيرفر 1 | ae11     | 1     | 10-07-2012 |
      | ae  | ts2        | ts2.travian.ae            | السيرفر 2 | ae22     | 1     | 30-08-2012 |
      | cl  | ts5        | ts5.travian.cl            | Server 5    |          | 3     | 28-01-2013 |
      | cl  | tcx3       | tcx3.travian.cl           | Server 17   |          | 3     | 21-11-2012 |
      | com | ts1        | ts1.travian.com           | Server 1    | com11    | 1     | 08-07-2012 |
      | de  | tcx8       | tcx8.travian.de           | Speed 8x    |          | 8     | 11-12-2012 |
      | tr  | cumhuriyet | cumhuriyet.travian.com.tr | Cumhuriyet  | tr8989   | 2     | 08-11-2012 |
    When I run the task `rake db:seed`
    Then I should have loaded 8 hubs
    And I should have 2 mirrors
    And I should have 6 main hubs
    And I should have loaded 7 servers
    And I should have loaded 7 rounds
