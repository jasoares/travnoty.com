class ServersController < ApplicationController

  def index
    scope = Server.includes(:hub, :rounds).scoped
    @restarting_servers = scope.restarting
    @running_servers = scope.running
    @ended_servers = scope.ended
  end

  def show
    @server = Server.includes(:hub, :rounds).find(params[:id])
  end
end
