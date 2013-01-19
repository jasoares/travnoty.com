module Updater
  extend self

  def detect_new_servers
    Hub.main_hubs.each do |hub|
      detect_new_servers_from(hub)
    end
  end

  def detect_finished_servers
    Hub.main_hubs.each {|hub| detect_finished_servers_from(hub) }
  end

  def servers_not_found
    Hub.main_hubs.inject([]) do |ary,hub|
      ary + servers_not_found_from(hub)
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

  def detect_finished_servers_from(hub)
    servers_not_found_from(hub).each {|s| s.update_attribute(:end_date, Date.today) }
  end

  def servers_not_found_from(hub)
    code = hub.code.to_sym
    servers_found = Travian.hubs[code].servers.map {|s| Server.find_by_host(s.host) }
    hub.active_servers - servers_found
  rescue Exception => msg
    UpdateReporter.update_error(hub, msg).deliver
  end

end
