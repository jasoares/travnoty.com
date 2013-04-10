class Api::BaseController < ApplicationController
  before_filter :restrict_access

  private

  def restrict_access
    authenticate_or_request_with_http_token do |token, options|
      User.authenticate_with_key(token)
    end
  end

end
