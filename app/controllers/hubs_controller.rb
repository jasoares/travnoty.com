class HubsController < ApplicationController

  def index
    @hubs = Hub.select("hubs.*, servers.id").includes(:servers).order("hubs.name asc")
  end

  def show
    @hub = Hub.includes(:servers => :rounds).scoped
    @hub = @hub.find_by_code(params[:code]) if params[:code]
    @hub = @hub.find(params[:id]) if params[:id]
  end
end
