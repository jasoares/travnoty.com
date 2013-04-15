class Api::V1::ServersController < Api::V1::BaseController
  respond_to :json

  def index
    @servers = Server.all
    expires_in 1.day, :public => true
    last_modified = @hubs.empty? ? nil : Server.order(:updated_at).last.updated_at
    if stale?(last_modified: last_modified, etag: @servers)
      respond_with @servers
    end
  end

  def show
    @server = Server.includes(:rounds).find(params[:id])
    expires_in 1.day, :public => true
    last_modified = @server.current_round.updated_at
    if stale?(last_modified: last_modified, etag: @server)
      respond_with @server
    end
  end

  def active
    respond_with Server.active
  end

  def archived
    respond_with Server.archived
  end
end
