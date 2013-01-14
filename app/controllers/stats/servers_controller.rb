class Stats::ServersController < ApplicationController
  def index
    @servers = Server.includes(:hubs).all(:order => 'servers.start_date DESC')
    @total_servers = Server.count
  end

  def show
    @server = Server.find(params[:id])
  end
end
