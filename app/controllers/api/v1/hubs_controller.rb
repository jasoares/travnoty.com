class Api::V1::HubsController < Api::V1::BaseController
  respond_to :json

  def index
    @hubs = Hub.order(:name).all
    expires_in 10.day, :public => true
    last_modified = @hubs.empty? ? nil : Hub.order(:updated_at).last.updated_at
    if stale?(last_modified: last_modified, etag: @hubs)
      respond_with @hubs
    end
  end

  def show
    @hub = Hub.find(params[:id])
    expires_in 1.day, :public => true
    if stale?(last_modified: @hub.updated_at.utc, etag: @hub)
      respond_with @hub
    end
  end

  def servers
    @servers = Hub.find(params[:id]).servers.order(:host)
    expires_in 1.day, :public => true
    if stale?(last_modified: Server.where(:id => @servers).order(:updated_at).last.updated_at, etag: @servers)
      respond_with @servers
    end
  end

  def supported_servers
    @servers = Hub.find(params[:id]).servers.without_classics.order(:host)
    expires_in 1.day, :public => true
    if stale?(last_modified: Server.where(:id => @servers).order(:updated_at).last.updated_at, etag: @servers)
      respond_with @servers
    end
  end
end
