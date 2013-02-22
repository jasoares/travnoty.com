class Api::V1::ServersController < Api::V1::BaseController
  respond_to :json

  def index
    respond_with Server.all
  end

  def show
    respond_with Server.find(params[:id])
  end

  def active
    respond_with Server.active
  end

  def archived
    respond_with Server.archived
  end
end
