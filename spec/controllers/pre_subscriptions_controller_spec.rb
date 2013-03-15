require 'spec_helper'

describe PreSubscriptionsController do

  describe 'GET #new' do
    it "returns http success" do
      get 'new'

      response.should be_success
    end

    it 'assigns @hubs with a new user record' do
      pre_subscription = PreSubscription.new
      get :new

      expect(assigns(:pre_subscription)).to be_a_new PreSubscription
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new pre subscription' do
        expect {
          post :create, pre_subscription: attributes_for(:pre_subscription)
        }.to change { PreSubscription.count }.from(0).to(1)
      end

      it 'redirects to root url' do
        post :create, pre_subscription: attributes_for(:pre_subscription)

        response.should redirect_to root_url
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new pre subscription' do
        expect {
          post :create, pre_subscription: attributes_for(:pre_subscription, name: '')
        }.not_to change(PreSubscription, :count)
      end

      it "returns http success" do
        post :create, pre_subscription: attributes_for(:pre_subscription, name: '')

        response.should render_template :new
      end
    end
  end

end
