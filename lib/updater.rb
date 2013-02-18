require 'travian_loader'

module Updater
  extend self

  def detect_new_servers
    TravianLoader.servers.each do |server|
      add_server(server) unless Server.exists?(host: server.host)
    end
  end

  def detect_ended_rounds
    Round.includes(:server).running.each do |round|
      end_round(round) if TravianLoader::Server(round.server).ended?
    end
  end

  def detect_new_rounds
    Server.ended.each do |server|
      round = TravianLoader::Server(server)
      add_round(round, server) if round.restarting?
    end
  end

  private

  def add_server(server)
    Hub.find_by_code(server.hub_code).servers << Server.new(server.attributes)
    log("Server #{server.host} added.")
  end

  def add_round(round, server_record)
    server_record.rounds << Round.new(start_date: round.restart_date, version: round.version)
    log("Restarting round on #{round.restart_date} for #{server_record.host} added.")
  end

  def end_round(round)
    round.update_attribute(:end_date, Date.today.to_datetime)
    log("Current round ended for server #{round.server.host}")
  end

  def log(message)
    Rails.logger.info "[TravianUpdater:#{DateTime.now}] #{message}"
  end
end
