require 'rake'

Rake.application.rake_require 'active_record/railties/databases'
Rake.application.rake_require 'tasks/update'
Rake::Task.define_task(:environment)

Given /^I have a clean database$/ do
  step "I have no hubs"
  step "I have no servers"
  step "I have no rounds"
end

Given /^they are already loaded in the database$/ do
  step "I run the task `rake db:seed`"
end

When /^I run the task `rake (\w+(?:\:\w+))`$/ do |task|
  Rake::Task[task].reenable
  Rake.application.invoke_task task
end
