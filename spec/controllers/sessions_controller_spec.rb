require 'spec_helper'

describe SessionsController do
  let(:user) { create(:user) }
  let(:params) { { handle: user.email, password: user.password } }

  describe "GET #new" do
    it "returns http success" do
      get :new
      response.should be_success
    end

    it 'redirects to users/profile when successfully signed in' do
      post :create, params
      get :new

      response.should redirect_to profile_path
    end
  end

  describe "POST #create" do
    it "redirects to users/profile when successfully signed in" do
      post :create, params
      post :create

      response.should redirect_to profile_path
      flash[:notice].should == 'Signed in!'
    end

    it 'sets the session[:user_id] to the user id' do
      post :create, params

      session[:user_id].should == user.id
    end

    it "renders new when invalid email or password are passed" do
      post :create, handle: '', password: ''

      response.should render_template :new
      flash[:alert].should == 'Invalid email or password'
    end
  end

  describe "DELETE #destroy" do
    it 'deletes the user_id from session' do
      post :create, params
      expect {
        delete :destroy
      }.to change { session[:user_id] }.from(user.id).to(nil)
    end

    it "redirects to the root_path" do
      post :create, params
      delete :destroy

      response.should redirect_to root_path
    end
  end

end
