class Api::V1::BaseController < Api::BaseController
  after_filter :set_content_type

  def set_content_type
    response.content_type = "application/vnd.travnoty.v1+json"
  end
end
