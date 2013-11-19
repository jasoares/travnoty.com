class Api::V1::UsersController < Api::V1::BaseController
  skip_before_filter :restrict_access, only: [:create]

  def create
    @user = User.new(permitted_params.user)
    if @user.save
      respond_with @user, location: users_path(@user)
    else
      render :text => "#{@user.errors.first}", :status => :bad_request
    end
  end

  def show
    @user = User.find(params[:id])
    if @user
      respond_with @user, :include => :travian_accounts
    else
      render :status => :not_found
    end
  end
end
