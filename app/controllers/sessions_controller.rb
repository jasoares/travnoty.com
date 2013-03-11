class SessionsController < ApplicationController
  before_filter :redirect_to_profile, :if => :signed_in?, only: [:new, :create]
  def new
  end

  def create
    user = User.authenticate(params[:handle], params[:password])
    if user
      user.increment(:sign_in_count)
      user.update_attributes(last_sign_in_at: DateTime.now.utc)
      sign_in user
      redirect_to profile_path, :notice => 'Signed in!'
    else
      flash.now.alert = "Invalid email or password"
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url, :notice => 'Signed out!'
  end
end
