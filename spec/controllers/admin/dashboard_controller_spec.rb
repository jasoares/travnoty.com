require 'spec_helper'

describe Admin::DashboardController do
  describe 'GET #index' do
    context 'when the admin is not signed in' do
      it 'assigns @admin with an Admin record' do
        get :index

        assigns(:admin).should be_an Admin
      end

      it 'renders the index template' do
        get :index

        response.should render_template :index
      end
    end
  end
end
