require 'spec_helper'

describe UsersController do

  describe "GET #new" do
    it "returns http success" do
      get :new

      response.should be_success
    end

    it 'assigns @user with a new user record' do
      get :new

      expect(assigns(:user)).to be_a_new User
    end

    it 'redirects to user account if the user is already signed in' do
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

      it 'redirects to user account with notice "Signed up!"' do
        post :create, user: attributes_for(:user)

        response.should redirect_to account_path
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

  describe 'PUT #update' do
    let(:user) { create(:user) }

    context 'given the user is not signed in' do
      before { controller.stub(signed_in?: false) }

      it 'redirects to the sign in page' do
        put :update, id: user.id, user: user.attributes

        response.should redirect_to sign_in_path
      end
    end

    context 'given the user is signed in' do
      before { controller.stub(current_user: user) }

      it 'renders the account settings template' do
        put :update, id: user.id, user: user.attributes

        response.should render_template 'accounts/settings'
      end

      context 'given a valid email attribute' do
        it 'it sets the proper flash notice' do
          put :update, id: user.id, user: { email: 'johndoe@example.com' }

          flash[:notice].should == 'An email was sent with verification instructions'
        end
      end

      context 'given invalid params' do
        it 'it sets the proper flash notice' do
          put :update, id: user.id, user: { email: 'invalid' }

          flash[:alert].should == 'Nothing was changed'
        end
      end

      context 'given a valid username or/and name attributes' do
        it 'it sets the proper flash notice' do
          put :update, id: user.id, user: { name: 'John Doe' }

          flash[:notice].should == 'Your profile information was updated'
        end
      end
    end
  end

  describe 'GET #confirm_email' do
    let(:user) { create(:user) }

    context 'given the user is not signed in' do
      it 'redirects to the sign in page' do
        get :confirm_email, id: user.id, confirmation_token: user.confirmation_token

        response.should redirect_to sign_in_path
      end
    end

    context 'given the user is signed in with another account' do
      let(:user) { create(:user) }
      let(:another_user) { create(:user) }

      before { controller.stub(current_user: another_user) }

      it 'redirects to the sign in page again' do
        get :confirm_email, id: user.id, confirmation_token: user.confirmation_token

        response.should redirect_to sign_in_path
      end

      it 'sets a flash error to "Please sign in with the account associated to the email"' do
        get :confirm_email, id: user.id, confirmation_token: user.confirmation_token

        flash[:error].should == "Please sign in with the account associated to the email"
      end
    end

    context 'given the user is signed in with the right account' do
      before { controller.stub(current_user: user) }

      context 'given the email is already confirmed' do
        before { user.stub(:confirmed? => true) }

        it 'sets flash notice to "Your email was already verified' do
          get :confirm_email, id: user.id, confirmation_token: user.confirmation_token

          flash[:notice].should == "Your email was already verified"
        end
      end

      context 'given the email is not confirmed already' do
        before { user.stub(:confirmed? => false) }

        context 'given a valid confirmation_token' do
          before { user.stub(:confirm! => true) }

          it 'redirects to account settings' do
            get :confirm_email, id: user.id, confirmation_token: user.confirmation_token

            response.should redirect_to account_path
          end

          it 'calls #confirm! on user with the confirmation token' do
            user.should_receive(:confirm!).with(user.confirmation_token)

            get :confirm_email, id: user.id, confirmation_token: user.confirmation_token
          end

          it 'sets flash notice to "Your email has been verified"' do
            get :confirm_email, id: user.id, confirmation_token: user.confirmation_token

            flash[:notice].should == "Your email has been verified"
          end
        end

        context 'given an invalid or already used confirmation token' do
          it 'sets flash error to "Confirmation token not found"' do
            get :confirm_email, id: user.id, confirmation_token: 'invalid'

            flash[:error].should == "Confirmation token not found"
          end
        end
      end
    end
  end

end
