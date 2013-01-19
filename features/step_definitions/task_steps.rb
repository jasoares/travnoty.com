require 'rake'

When /^I run the task `rake ([\w\:]+)(?:\[(.+)\])?`$/ do |task, arg|
  @rake = Rake::Application.new
  Rake.application = @rake
  Rake.application.rake_require 'active_record/railties/databases'
  Rake.application.rake_require 'tasks/update'
  Rake::Task.define_task(:environment)
  @rake[task].invoke(arg)
  @rake[task].reenable
end
