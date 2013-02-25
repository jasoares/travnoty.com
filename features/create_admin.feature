Feature: Create Admin
  As an application administrator
  In order to perform maintainance tasks
  I need to have a priviledged account

  Scenario: Creating an Administrator
    Given there are no admins
    And I have set the ENV['ADMIN_EMAIL'] to 'admin@travnoty.com'
    And I have set the ENV['ADMIN_PASSWORD'] to 'adminpassword'
    When I run the task `rake admin:create`
    Then I should have 1 admin
    And its email should be "admin@travnoty.com"
