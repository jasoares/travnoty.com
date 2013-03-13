require 'spec_helper'

describe SettingsController do

  describe "GET 'account'" do
    it "returns http success" do
      get 'account'
      response.should be_success
    end
  end

  describe "GET 'notifications'" do
    it "returns http success" do
      get 'notifications'
      response.should be_success
    end
  end

end
