class Api::V1::BaseController < Api::BaseController
  after_filter :set_media_type

  def set_media_type
    response.headers['X-Travnoty-Media-Type'] = "application/vnd.travnoty.v1+json"
  end
end
