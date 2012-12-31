# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

Hub.observers.disable :all do
  Travian.hubs.each do |hub|
    record = Hub.find_or_initialize_by_code(hub.code)
    record.attributes = hub.attributes
    record.save if record.new_record? or record.changed?
  end
end

Server.observers.disable :all do
  Hub.all.each do |hub|
    servers = Travian.hubs[hub.code.to_sym].servers.map do |server|
      record = Server.find_or_initialize_by_host(server.host)
      record.attributes = server.attributes
      record.save if record.new_record? or record.changed?
      record
    end
    hub.servers << servers
  end
end
