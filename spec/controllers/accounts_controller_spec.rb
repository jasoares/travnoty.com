require 'spec_helper'

describe AccountsController do

  describe 'GET #settings' do
    context 'given the user is signed in' do
      before { controller.stub(signed_in?: true) }

      it 'renders the show template' do
        get 'settings'

        response.should render_template 'settings'
      end
    end

    context 'given the user is not signed in' do
      it 'redirects to the sign in page' do
        get 'settings'

        response.should redirect_to sign_in_path
      end
    end
  end

  describe "GET 'notifications'" do
    context 'given the user is signed in' do
      before { controller.stub(signed_in?: true) }

      it "returns http success" do
        get 'notifications'
        response.should render_template :notifications
      end
    end

    context 'given the user is not signed in' do
      before { controller.stub(signed_in?: false) }

      it 'redirects to sign in' do
        get 'notifications'

        response.should redirect_to sign_in_path
      end
    end
  end

  describe "GET 'billing'" do
    context 'given the user is signed in' do
      before { controller.stub(signed_in?: true) }

      it "returns http success" do
        get 'billing'
        response.should render_template :billing
      end
    end

    context 'given the user is not signed in' do
      before { controller.stub(signed_in?: false) }

      it 'redirects to sign in' do
        get 'billing'

        response.should redirect_to sign_in_path
      end
    end
  end

  describe "GET 'payments'" do
    context 'given the user is signed in' do
      before { controller.stub(signed_in?: true) }

      it "returns http success" do
        get 'payments'
        response.should render_template :payments
      end
    end

    context 'given the user is not signed in' do
      before { controller.stub(signed_in?: false) }

      it 'redirects to sign in' do
        get 'payments'

        response.should redirect_to sign_in_path
      end
    end
  end
end
