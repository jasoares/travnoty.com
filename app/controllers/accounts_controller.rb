class AccountsController < ApplicationController
  before_filter :require_login, :unless => :signed_in?

  def settings
  end

  def travian_accounts
  end

  def notifications
  end

  def billing
  end

  def payments
  end
end
