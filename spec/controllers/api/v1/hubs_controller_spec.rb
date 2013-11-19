require 'spec_helper'

describe Api::V1::HubsController do
  it 'should set response Content-Type to "applicattion/vnd.travnoty.v1+json"' do
    get :index

    response.headers['X-Travnoty-Media-Type'].should == "application/vnd.travnoty.v1+json"
  end

  context 'GET #index' do
    before { create_list(:hub, 3) }

    it 'it renders the collection of all hubs as json' do
      get :index, format: :json

      response.body.should == Hub.order(:name).to_json
    end
  end

  context 'GET #show' do
    let(:hub) { create(:hub, :with_servers, :with_mirrors) }

    it 'renders the requested hub as json' do
      get :show, id: hub, format: :json

      response.body.should == hub.to_json
    end
  end
end
