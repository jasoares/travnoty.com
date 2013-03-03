class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    email = Email.new(address: params[:email], main_address: true)
    email.user = @user
    @user.emails = [email]
    if @user.save
      redirect_to root_url, :notice => 'Signed Up!'
    else
      render 'new'
    end
  end

  def profile
    @user = User.find(session[:user_id])
  end

  def confirm_email
    email = Email.where(user_id: params[:id], confirmation_token: params[:confirmation_token]).first
    if email
      redirect_to sign_in_path, :notice => 'Email confirmed successfully!'
    else
      redirect_to resend_confirmation_path, :notice => 'Confirmation token not found'
    end
  end

end
