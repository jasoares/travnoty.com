require 'spec_helper'

describe UsersController do

  describe "GET #new" do
    it "returns http success" do
      get :new

      response.should be_success
    end

    it 'assigns @user with a new user record' do
      user = User.new
      get :new

      expect(assigns(:user)).to be_a_new User
    end

    it 'redirects to profile path if the user is already signed in' do
      controller.stub(signed_in?: true)
      get :new

      response.should be_success
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the user id in the session' do
        expect {
          post :create, user: attributes_for(:user)
        }.to change { session[:user_id] }.from(nil).to(Integer)
      end

      it 'creates a new user with the associated email' do
        expect {
          post :create, user: attributes_for(:user)
        }.to change(User, :count).from(0).to(1)
      end

      it 'redirects to user profile with notice "Signed up!"' do
        post :create, user: attributes_for(:user)

        response.should redirect_to profile_path
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new user' do
        expect {
          post :create, user: attributes_for(:user, password: 'invalid')
        }.not_to change(User, :count)
      end

      it 'does not set user_id in the session' do
        expect {
          post :create, user: attributes_for(:user, password: 'invalid')
        }.not_to change { session[:user_id] }
      end

      it 're-renders the new method' do
        post :create, user: attributes_for(:user, password: 'invalid')

        response.should render_template :new
      end
    end
  end

  describe 'GET #show' do
    context 'given the user is signed in' do
      it 'renders the show template' do
        controller.stub(signed_in?: true)
        get :show

        response.should render_template :show
      end
    end

    context 'given no one is signed in' do
      it 'redirects to the sign in page' do
        get :show

        response.should redirect_to sign_in_path
      end
    end
  end
end
