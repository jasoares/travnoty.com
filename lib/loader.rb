module Loader
  extend self

  def load_hubs
    Travian.hubs.each do |hub|
      Hub.create(hub.attributes)
    end
  rescue Travian::ConnectionTimeout => msg
    puts "Could not connect to hub '#{Travian::MAIN_HUB}'(main hub) (#{msg})"
  end

  def load_servers
    Travian.hubs(preload: :all).each do |hub|
      hub_record = Hub.find_by_code(hub.code)
      hub.servers.each do |server|
        record = Server.new(server.attributes)
        hub_record.servers << record
      end if hub_record && !hub.is_mirror?
    end
  rescue Travian::ConnectionTimeout => msg
    puts "Could not connect to hub/server (#{msg})"
  end

  def detect_mirrors
    Travian.hubs(preload: :servers).each do |hub|
      record = Hub.find_by_code(hub.code)
      next unless record
      if hub.mirrored_hub
        record.mirrors_hub_id = Hub.find_by_code(hub.mirrored_hub.code).id
        record.save
      end
    end
  rescue Travian::ConnectionTimeout => msg
    puts "Could not connect to hub/server (#{msg})"
  end

  def load_rounds
    Travian.hubs(preload: :all).each do |hub|
      next if hub.is_mirror?
      hub.servers.each do |server|
        server_record = Server.find_by_host(server.host)
        next unless server_record
        round = Round.new(start_date: server.start_date, version: server.version)
        server_record.rounds << round
      end
    end
  rescue Travian::ConnectionTimeout => msg
    puts "Could not connect to hub/server (#{msg})"
  end
end
