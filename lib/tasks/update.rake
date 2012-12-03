namespace :update do
  desc "Update Hubs table with all Travian Hubs from http://www.travian.com/"
  task :hubs => :environment do
    Hub.update!
    puts "Updated Hubs table, check #{Rails.env} logs for details or type:\n\ttail -f log/#{Rails.env}.log"
  end
end