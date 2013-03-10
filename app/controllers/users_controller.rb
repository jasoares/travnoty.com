class UsersController < ApplicationController
  before_filter :require_login, only: :show
  protect_from_forgery except: :create

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      session[:user_id] = @user.id
      redirect_to profile_path, :notice => 'Signed Up!'
    else
      render 'new'
    end
  end

  def show
  end

  def confirm_email
    email = Email.where(user_id: params[:id], confirmation_token: params[:confirmation_token]).first
    if email.confirm
      redirect_to sign_in_path, :notice => 'Email confirmed successfully!'
    else
      redirect_to resend_confirmation_path, :notice => 'Confirmation token not found'
    end
  end

end
