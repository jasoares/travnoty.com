class AccountsController < ApplicationController
  before_filter :require_login, :unless => :signed_in?

  def settings
  end

  def notifications
  end

  def billing
  end

  def payments
  end
end
