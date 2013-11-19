class UsersController < ApplicationController
  before_filter :require_login, :unless => :signed_in?, only: [:update, :confirm_email, :request_verification]
  before_filter :require_email_account_login, :if => :wrong_account?, only: [:confirm_email]
  protect_from_forgery except: :create

  def new
    @user = User.new
  end

  def create
    @user = User.new(permitted_params.user)
    if @user.save
      sign_in @user
      redirect_to account_path, :notice => 'Signed Up!'
    else
      render 'new'
    end
  end

  def update
    if current_user.update_attributes(permitted_params.user)
      if current_user.need_reconfirmation?
        flash.now[:notice] = 'An email was sent with verification instructions'
      else
        flash.now[:notice] = 'Your profile information was updated'
      end
    else
      flash.now[:alert] = 'Nothing was changed'
    end
    render 'accounts/settings'
  end

  def confirm_email
    msg = if current_user.confirmed?
      flash[:notice] = "Your email was already verified"
    elsif current_user.confirm!(params[:confirmation_token])
      flash[:notice] = "Your email has been verified"
    else
      flash[:error] = "Confirmation token not found"
    end
    redirect_to account_path
  end

  def request_verification
    if @user.resend_confirmation_instructions
      flash.now[:notice] = 'An email was sent with new verification instructions'
    else
      flash.now[:notice] = 'Your email is already verified'
    end
    render 'accounts/settings'
  end

protected

  def wrong_account?
    current_user.id != params[:id].to_i
  end

  def require_email_account_login
    sign_out
    session[:return_to] = request.fullpath
    flash[:error] = "Please sign in with the account associated to the email"
    redirect_to sign_in_path
  end

end
