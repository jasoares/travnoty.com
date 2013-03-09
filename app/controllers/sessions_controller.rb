class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.authenticate(params[:email], params[:password])
    if user
      user.increment(:sign_in_count)
      user.update_attributes(last_sign_in_at: DateTime.now.utc)
      session[:user_id] = user.id
      redirect_to profile_path, :notice => 'Signed in!'
    else
      flash.now.alert = "Invalid email or password"
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => 'Signed out!'
  end
end
