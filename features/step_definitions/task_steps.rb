require 'rake'

Rake.application.rake_require 'active_record/railties/databases'
Rake.application.rake_require 'tasks/travian'
Rake::Task.define_task(:environment)

class Rake::Task
  # Recursively retrieve all task's prerequisite_tasks
  def prerequisite_tasks!(limit=30, options={})
    self.prerequisite_tasks.inject([]) do |tasks, task|
      tasks << task
      unless task.prerequisite_tasks.empty? or limit < 1
        tasks += task.prerequisite_tasks!(limit-1)
      end
      tasks
    end
  end
end

Given /^I have a clean database$/ do
  step "I have no hubs"
  step "I have no servers"
  step "I have no rounds"
end

Given /^they are already loaded in the database$/ do
  step "I run the task `rake travian:load`"
end

When /^I run the task `rake (\w+(?:\:\w+)*)`$/ do |task|
  task = Rake::Task[task]
  task.reenable
  task.prerequisite_tasks!.each(&:reenable)
  task.invoke
end
