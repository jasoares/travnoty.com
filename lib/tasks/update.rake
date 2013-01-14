namespace :update do
  desc 'Update database Travian servers for the passed hub code'
  task :servers, [:hub] => :environment do |t, args|
    begin
      Hub.find_by_code(args[:hub]).update_servers!
    rescue Exception => msg
      UpdateReporter.update_error(args[:hub], msg).deliver
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
