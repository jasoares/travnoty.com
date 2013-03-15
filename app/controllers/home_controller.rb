class HomeController < ApplicationController
  before_filter :redirect_to_profile, :if => :signed_in?

  def welcome
    @user = User.new
  end

  private :welcome if ENV['PRELAUNCH']

  def pre_welcome
    @hubs = Hub.main_hubs.order(:name).all
    @pre_subscription = PreSubscription.new
  end
end
