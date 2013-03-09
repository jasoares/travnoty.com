class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def require_login
    unless signed_in?
      flash[:error] = "Please sign in."
      redirect_to sign_in_path
    end
  end

  def current_user
    @current_user ||= session[:user_id] && User.find(session[:user_id])
  end

  def signed_in?
    !!current_user
  end
end
