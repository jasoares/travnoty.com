require 'spec_helper'

describe SessionsController do

  describe "GET #new" do
    it "returns http success" do
      get :new
      response.should be_success
    end
  end

  describe "GET #create" do
    let(:user) { create(:user_with_email) }

    it "redirects_to users/profile when successfully signed in" do
      post :create, email: user.email, password: user.password

      response.should redirect_to profile_path
      flash[:notice].should == 'Signed in!'
    end

    it 'sets the session[:user_id] to the user id' do
      post :create, email: user.email, password: user.password

      session[:user_id].should == user.id
    end

    it "renders new when invalid email or password are passed" do
      post :create, email: '', password: ''

      response.should render_template :new
      flash[:alert].should == 'Invalid email or password'
    end
  end

  describe "GET #destroy" do
    it "returns http success" do
      get 'destroy'

      response.should redirect_to root_path
      session[:user_id].should be_nil
    end
  end

end
