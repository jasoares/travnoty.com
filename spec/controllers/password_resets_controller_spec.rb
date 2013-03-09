require 'spec_helper'

describe PasswordResetsController do

  describe 'GET #new' do
    it 'returns http success' do
      get 'new'
      response.should be_success
    end
  end

  describe 'POST #create' do
    it 'renders new with an alert message when passed an unknown email address' do
      post :create, :email => 'unknown@example.com'

      response.should render_template :new
      flash[:alert].should == 'There is no account associated with that email.'
    end

    it 'sends password reset instructions and redirects to root url when passed a valid email address' do
      user = create(:user_with_email)
      post :create, :email => user.email

      response.should redirect_to root_url
      flash[:notice].should == 'An email was sent with password reset instructions.'
    end
  end

  describe 'GET #edit' do
    it "returns http success" do
      user = create(:user_with_email)
      user.send_password_reset

      get :edit, id: user.reset_password_token
      response.should be_success
    end

    it 'redirects to sessions/new if no valid reset token is passed' do
      get :edit, id: ''
      response.should redirect_to sign_in_path
    end

  end

  describe 'POST #update' do
    before(:each) do
      @user = create(:user_with_email)
      @user.send_password_reset
    end

    it 'redirects to sessions/new if the password is reset successfully' do
      post :update, id: @user.reset_password_token, user: { password: 'mysecretpass' }

      response.should redirect_to sign_in_path
      flash[:notice].should == 'Password has been reset!'
    end

    it 'redirects to password_resets/new if the reset token has expired' do
      Timecop.freeze(4.hours.from_now)
      post :update, id: @user.reset_password_token
      Timecop.return

      response.should redirect_to new_password_reset_path
      flash[:alert].should == 'Password reset has expired.'
    end

    it 'renders :edit again if the password is invalid or does not pass validations' do
      @user.stub(:change_password).and_return(false)
      post :update, id: @user.reset_password_token, user: { password: 'secret' }
      response.should render_template :edit
    end

  end

end
