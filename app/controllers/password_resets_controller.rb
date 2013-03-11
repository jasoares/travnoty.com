class PasswordResetsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user
      user.send_reset_password_instructions
      redirect_to root_url, :notice => "An email was sent with password reset instructions."
    else
      flash.now.alert = 'There is no account associated with that email.'
      render :new
    end
  end

  def edit
    @user = User.find_by_reset_password_token(params[:id])
    redirect_to(sign_in_path, :alert => 'Invalid reset password token') unless @user
  end

  def update
    @user = User.find_by_reset_password_token(params[:id])
    if @user.reset_token_sent_at < 3.hours.ago
      redirect_to new_password_reset_path, :alert => 'Password reset has expired.'
    elsif @user.reset_password(params[:user][:password], params[:user][:password_confirmation])
      redirect_to sign_in_path, :notice => 'Password has been reset!'
    else
      render :edit
    end
  end
end
