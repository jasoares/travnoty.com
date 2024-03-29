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
      begin
        round = TravianLoader::Server(server)
        add_round(round, server) if round.restarting?
      rescue Travian::ConnectionTimeout => e
        warn(e.message)
      end
    end
  end

  private

  def add_server(server)
    added = Hub.find_by_code(server.hub_code).servers << Server.new(server.attributes)
    log("Server #{server.host} added.") if added
  end

  def add_round(round, server_record)
    round_record = Round.new(start_date: round.restart_date, version: round.version)
    server_record.rounds << round_record
    UpdateReporter.start_round_notice(round_record).deliver
    log("Restarting round on #{round.restart_date} for #{server_record.host} added.")
  end

  def end_round(round)
    if round.update_attributes(end_date: Date.today.to_datetime)
      UpdateReporter.end_round_notice(round).deliver
      log("Current round ended for server #{round.server.host}")
    end
  end

  def log(message)
    Rails.logger.info "[TravianUpdater:#{DateTime.now}] #{message}"
  end

  def warn(message)
    Rails.logger.warn "[TravianUpdater:#{DateTime.now}][Warning] #{message}"
  end
end
