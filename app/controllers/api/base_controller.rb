class Api::BaseController < ApplicationController
  respond_to :json
  before_filter :restrict_access

  def current_user
    @current_user
  end

  private

  def restrict_access
    authenticate_or_request_with_http_token do |token, options|
      @current_user = User.authenticate_with_key(token)
    end
  end

end
