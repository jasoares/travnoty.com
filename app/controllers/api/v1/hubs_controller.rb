class Api::V1::HubsController < ApplicationController
  respond_to :json

  def index
    respond_with Hub.all
  end

  def show
    respond_with Hub.find(params[:id])
  end

  def servers
    respond_with Server.joins(:hubs).where('hubs_servers.hub_id = ?', params[:id])
  end

  def active_servers
    respond_with Server.joins(:hubs).active.where('hubs_servers.hub_id = ?', params[:id])
  end

  def archived_servers
    respond_with Server.joins(:hubs).archived.where('hubs_servers.hub_id = ?', params[:id])
  end
end
