namespace :fetch do
  
  desc "Seed database with initial take skiping model observers"
  task :all, [:no_observers] do |t, args|
    Hub.observers.disable :all do
      Rake::Task[:hubs]
      Rake::Task[:servers]
    end
  end

  desc 'Fetch Travian Hubs and update the database'
  task :hubs => :environment do
    Hub.update!
  end

  desc 'Fetch Travian Servers and update the dabase'
  task :servers => :environment do
    Hub.all.each {|hub| Server.update!(hub) }
  end
end
