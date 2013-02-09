module Updater
  extend self

  def detect_new_servers
    Travian.servers.each do |server|
      next if Server.find_by_host(server.host)
      hub_record = Hub.find_by_code(server.hub_code)
      hub_record.servers << Server.new(server.attributes)
    end
  end

  def detect_ended_rounds
    Round.includes(:server).running.each do |round|
      server = Travian::Server(round.server)
      round.update_attribute(:end_date, Date.today.to_datetime) if server.ended?
    end
  end

  def detect_new_rounds
    Round.includes(:server).ended.each do |round|
      server_record = round.server
      server = Travian::Server(round.server)
      server_record.rounds << Round.new(start_date: server.restart_date) if server.restarting?
    end
  end

  def detect_first_server_round
    Server.without_rounds.each do |server_record|
      server = Travian::Server(server_record)
      server_record.rounds << Round.new(start_date: server.restart_date) if server.restarting?
    end
  end

  def check_for_missing_running_rounds
    Travian.running_servers.each do |server|
      server_record = Server.includes(:rounds).find_by_host(server.host)
      current_round = server_record.current_round
      next if current_round && current_round.running?
      next if server_record.host == 'ts2.travian.ph'
      raise StandardError, "This should not have happened #{server.host}"
    end
  end
end
