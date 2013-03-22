class PasswordsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user
      user.send_reset_password_instructions
      msg = "An email was sent with password reset instructions"
      if signed_in?
        redirect_to account_path, :notice => msg
      else
        redirect_to root_url, :notice => msg
      end
    else
      flash.now[:error] = 'There is no account associated with that email'
      render :new
    end
  end

  def edit
    @user = User.find_by_reset_password_token(params[:id])
    if @user.nil? or @user.reset_period_expired?
      flash[:error] = "The reset password token is invalid or has expired. Please request a new one"
      redirect_to new_password_path
    end
  end

  def update
    @user = User.find_by_reset_password_token(params[:id])
    if @user.reset_period_expired?
      flash[:error] = 'Password reset has expired. Enter your email below to request a new one'
      redirect_to new_password_path
    elsif @user.reset_password(params[:user][:password], params[:user][:password_confirmation])
      sign_in @user
      redirect_to account_path, :notice => 'Password has been reset'
    else
      render :edit
    end
  end
end
