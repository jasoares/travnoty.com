class ServersController < ApplicationController

  layout 'info'

  def index
    restarting = Server.includes(:hub, :rounds).restarting
    @restarting_servers_count = restarting.count
    @last_restarting_servers = restarting.order("rounds.start_date asc").limit(3)
    recent = Server.includes(:rounds).references(:rounds).where("rounds.start_date between ? AND ?", 1.week.ago, DateTime.now)
    @recently_started_servers_count = recent.count
    @recently_started_servers = recent.includes(:hub).order("rounds.start_date desc").limit(3)
  end

  def show
    @server = Server.includes(:hub, :rounds).find(params[:id])
  end

  def scheduled
    @scheduled_servers = Server.includes(:hub, :rounds).
      restarting.
      order("rounds.start_date asc")
  end

  def recently_started
    @recently_started_servers = Server.includes(:hub, :rounds).
      where("rounds.start_date between ? AND ?", 1.week.ago, DateTime.now).
      references(:rounds).
      order("rounds.start_date desc")
  end
end
