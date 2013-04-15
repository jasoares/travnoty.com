class Api::V1::TravianAccountsController < Api::V1::BaseController

  def index
    respond_with current_user.travian_accounts
  end

  def create
    @travian_account = TravianAccount.new(uid: params[:uid], username: params[:username])
    @travian_account.user = @current_user
    @travian_account.round = Round.find(params[:round_id])
    if @travian_account.save
      respond_with @travian_account, location: travian_account_path(@travian_account)
    else
      render :text => "#{@travian_account.errors.first}", :status => :bad_request
    end
  end
end
