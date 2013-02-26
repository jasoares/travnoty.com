class Admin::DashboardController < ApplicationController

  def index
    @admin = Admin.new
  end

end
