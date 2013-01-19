require 'updater'

namespace :update do
  desc 'Update database Travian servers for the passed hub code'
  task :servers, [:hub] => :environment do |t, args|
    if args[:hub].nil?
      Updater.detect_finished_servers
      Updater.detect_new_servers
    else
      hub = Hub.find_by_code(args[:hub])
      Updater.detect_finished_servers_from(hub)
      Updater.detect_new_servers_from(hub)
    end
  end

  desc 'Update all database Travian servers'
  task :hubs => :environment do
    Hub.all.each do |hub|
      Rake::Task['update:servers'].invoke(hub.code)
      Rake::Task['update:servers'].reenable
    end
  end
end
