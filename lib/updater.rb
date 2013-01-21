module Updater
  extend self

  def detect_new_servers
    Hub.main_hubs.each do |hub|
      detect_new_servers_from(hub)
    end
  end

  def detect_new_servers_from(hub)
    code = hub.code.to_sym
    Travian.hubs[code].servers.map do |s|
      server = Server.find_by_host(s.host)
      unless server
        record = Server.new(s.attributes)
        hub.servers << record
      end
    end
  rescue Exception => msg
    UpdateReporter.update_error(hub, msg).deliver
  end

end
