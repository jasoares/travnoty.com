namespace :travian do
  namespace :load do
    task :load_environment => :environment do
      require 'loader'
    end

    task :hubs => :load_environment do
      Loader.load_hubs
    end

    task :servers => :hubs do
      Loader.load_servers
    end

    task :rounds => :servers do
      Loader.load_rounds
    end

    task :all => :rounds
  end

  namespace :update do
    task :load_environment => :environment do
      require 'updater'
    end

    desc 'Detects new servers and adds them to the database'
    task :servers => :load_environment do
      Updater.detect_new_servers
    end

    desc 'Detects ended rounds and updates the database with the end date'
    task :ended_rounds => :load_environment do
      Updater.detect_ended_rounds
    end

    desc 'Detects new rounds starting in the future adds them to the database'
    task :new_rounds => :servers do
      Updater.detect_new_rounds
    end

    task :all => [:ended_rounds, :new_rounds]
  end

  desc 'Load database with Travian hubs, servers and rounds'
  task :load => 'load:all'

  desc 'Update database with new servers, ended rounds and restarting rounds'
  task :update => 'update:all'
end
