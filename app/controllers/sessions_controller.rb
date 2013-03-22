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
      url = session[:return_to] || account_path
      session[:return_to] = account_path
      redirect_to url
    else
      flash.now[:error] = "Invalid email or password"
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url, :notice => 'Signed out!'
  end
end
