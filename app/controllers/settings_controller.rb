class SettingsController < ApplicationController
  def account
    @user = User.find(session[:user_id])
  end

  def notifications
  end
end
