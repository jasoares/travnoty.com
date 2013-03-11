class UsersController < ApplicationController
  before_filter :require_login, only: :show
  protect_from_forgery except: :create

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      redirect_to profile_path, :notice => 'Signed Up!'
    else
      render 'new'
    end
  end

  def show
  end

  def confirm_email
    user = User.where(confirmation_token: params[:confirmation_token]).first
    if user
      msg = if user.confirmed?
        "Your email was already verified."
      else
        user.confirm
        "Your email has been verified."
      end
      sign_in user
      redirect_to profile_path, :notice => msg
    else
      redirect_to root_url, :notice => 'Confirmation token not found'
    end
  end

end
