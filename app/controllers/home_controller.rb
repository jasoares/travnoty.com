class HomeController < ApplicationController
  def welcome
    @user = User.new
  end
end
