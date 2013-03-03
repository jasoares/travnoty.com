require 'spec_helper'

describe UsersController do

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end

    it 'assigns @user with a new user record' do
      user = User.new
      get 'new'

      assigns(:user).should be_a User
      assigns(:user).should be_new_record
    end
  end

end
