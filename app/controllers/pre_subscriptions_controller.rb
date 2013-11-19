class PreSubscriptionsController < ApplicationController
  def new
    @hubs = Hub.main_hubs.order(:name)
    @pre_subscription = PreSubscription.new
  end

  def create
    @hub = Hub.find_by_id(params[:hub] || 0)
    @pre_subscription = PreSubscription.new(permitted_params.pre_subscription)
    @pre_subscription.hub = @hub
    if @pre_subscription.save
      redirect_to root_url, :notice => "Thank you for your interest #{@pre_subscription.name}."
    else
      @hubs = Hub.main_hubs.order(:name)
      render :new
    end
  end
end
