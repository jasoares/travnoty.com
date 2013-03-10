class HomeController < ApplicationController
  before_filter :redirect_to_profile, :if => :signed_in?
  def welcome
    @user = User.new
  end
end
