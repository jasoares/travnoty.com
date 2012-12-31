require 'rake'

def require_rake_tasks(filename=nil)
  rake = Rake::Application.new
  Rake.application = rake
  Rake.application.rake_require 'active_record/railties/databases'
  Rake.application.rake_require(filename) if filename
  Rake::Task.define_task(:environment)
  rake
end

When /^I run the task `rake (.+)`$/ do |task|
  rake = require_rake_tasks
  rake[task].invoke
end
