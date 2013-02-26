class ApplicationController < ActionController::Base
  protect_from_forgery

  def after_sign_in_path_for(scope)
    scope.is_a?(User) ? root_path : admin_path
  end

  def after_sign_out_path_for(scope)
    request.referrer
  end
end
