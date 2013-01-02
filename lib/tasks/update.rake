namespace :update do
  desc 'Update database Travian servers for the passed hub code'
  task :servers, [:hub] => :environment do |t, args|
    code = args[:hub].to_sym
    hub = Hub.find_by_code(code)
    Travian.hubs[code].servers.map do |server|
      record = Server.find_or_initialize_by_host(server.host)
      record.attributes = server.attributes
      if record.new_record?
        puts "Added #{record.host} server from #{hub.name}."
        record.hubs << hub
      end
      if record.changed?
        puts "Updated #{record.host} server from #{hub.name}." unless record.new_record?
        record.save
      end
    end
    hub.servers.each do |server|
      server.end_date = Date.today if Travian.hubs[code].servers.all? {|s| s.host != server.host }
      server.save
    end
  end

  desc 'Update all database Travian servers'
  task :hubs => :environment do
    Hub.all.each do |hub|
      puts "Updating #{hub.name} server..."
      Rake::Task['update:servers'].invoke(hub.code)
      Rake::Task['update:servers'].reenable
    end
  end
end
