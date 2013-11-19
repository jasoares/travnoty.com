class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def require_login
    session[:return_to] = request.fullpath
    redirect_to sign_in_path
  end

  def current_user
    begin
      @user ||= session[:user_id] && User.find(session[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      session[:user_id] = nil
      redirect_to sign_in_path and return
    end
  end

  def redirect_to_profile
    redirect_to account_path
  end

  def signed_in?
    !!current_user
  end

  def sign_in(user)
    session[:user_id] = user.id
  end

  def sign_out
    session[:user_id] = nil
  end
end
