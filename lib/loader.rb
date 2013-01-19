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
    Server.observers.disable :all do
      Travian.hubs.each do |hub|
        hub_record = Hub.find_by_code(hub.code)
        hub.servers.each do |server|
          record = Server.new(server.attributes)
          hub_record.servers << record
        end if hub_record && !hub.is_mirror?
      end
    end
  rescue Travian::ConnectionTimeout => msg
    puts "Could not connect to hub/server (#{msg})"
  end

  def detect_mirrors
    Travian.hubs.each do |hub|
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
end