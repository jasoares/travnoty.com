require 'spec_helper'

describe UsersController do

  describe "GET #new" do
    it "returns http success" do
      get 'new'

      response.should be_success
    end

    it 'assigns @user with a new user record' do
      user = User.new
      get 'new'

      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe 'GET #show' do
  end
end
