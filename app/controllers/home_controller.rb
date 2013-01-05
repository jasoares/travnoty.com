class HomeController < ApplicationController
  layout 'application', :except => :welcome
  def welcome
    render :welcome, :layout => false
  end
end
