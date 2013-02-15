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
    Server.ended.each do |server_record|
      server = Travian::Server(server_record)
      round = Round.new(start_date: server.restart_date, version: server.version)
      server_record.rounds << round if server.restarting?
    end
  end

  def check_for_missing_running_rounds
    Travian.running_servers.each do |server|
      next if server.host == 'ts2.travian.ph'
      server_record = Server.includes(:rounds).find_by_host(server.host)
      next if server_record.current_round.running?
      raise StandardError, "This should not have happened #{server.host}"
    end
  end

  private

  def log(message)
    Rails.logger.info "[TravianUpdater:#{Time.now}] #{message}"
  end
end
