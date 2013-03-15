class PreSubscriptionsController < ApplicationController
  def new
    @hubs = Hub.main_hubs.order(:name).all
    @pre_subscription = PreSubscription.new
  end

  def create
    @hub = Hub.find_by_id(params[:pre_subscription].delete(:hub) || 0)
    @pre_subscription = PreSubscription.new(params[:pre_subscription])
    @pre_subscription.hub = @hub
    if @pre_subscription.save
      redirect_to root_url, :notice => "Thank you for your interest #{@pre_subscription.name}."
    else
      @hubs = Hub.main_hubs.order(:name).all
      render :new
    end
  end
end
