class Api::V1::HubsController < Api::V1::BaseController
  respond_to :json

  def index
    respond_with Hub.all
  end

  def show
    respond_with Hub.find(params[:id])
  end

  def servers
    respond_with Hub.find(params[:id]).servers
  end

  def active_servers
    respond_with Hub.find(params[:id]).active_servers
  end

  def archived_servers
    respond_with Hub.find(params[:id]).archived_servers
  end
end
