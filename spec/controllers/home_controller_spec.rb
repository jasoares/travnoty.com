require 'spec_helper'

describe HomeController do

  describe "GET 'welcome'" do
    it "returns http success" do
      get 'welcome'
      response.should be_success
    end

    it 'redirects to user profile if already signed in' do
      controller.stub(signed_in?: true)
      get :welcome

      response.should redirect_to profile_path
    end
  end

end
