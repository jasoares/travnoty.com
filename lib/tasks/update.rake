require 'updater'

namespace :update do
  desc 'Update servers and rounds from Travian'
  task :servers => :environment do
    Updater.detect_new_servers
    Updater.detect_ended_rounds
    Updater.detect_new_rounds
    Updater.detect_first_server_round
    Updater.check_for_missing_running_rounds
  end
end
