require 'travian_loader'

module Loader
  extend self

  def load_hubs
    TravianLoader.hubs(mirrors: true).each {|hub| Hub.create(hub.attributes) }
    Hub.all.each do |record|
      hub = TravianLoader::Hub(record)
      next unless hub.mirror?
      main_hub = Hub.find_by_code(hub.mirrored_hub.code)
      record.update_attribute(:main_hub_id, main_hub.id)
    end
  rescue Travian::ConnectionTimeout => msg
    puts "Could not connect to hub '#{Travian::MAIN_HUB}'(main hub) (#{msg})"
  end

  def load_servers
    TravianLoader.servers.each do |server|
      hub_record = Hub.find_by_code(server.hub_code)
      hub_record.servers << Server.new(server.attributes) if hub_record
    end
  rescue Travian::ConnectionTimeout => msg
    puts "Could not connect to hub/server (#{msg})"
  end

  def load_rounds
    TravianLoader.servers.each do |server|
      next unless server.running? || server.restarting?
      server_record = Server.find_by_host(server.host)
      next unless server_record
      start_date = server.restarting? ? server.restart_date : server.start_date
      server_record.rounds << Round.new(start_date: start_date, version: server.version)
    end
  rescue Travian::ConnectionTimeout => msg
    puts "Could not connect to hub/server (#{msg})"
  end
end
