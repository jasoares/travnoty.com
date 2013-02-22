require 'spec_helper'

describe Api::V1::HubsController do
  it 'should set response Content-Type to "applicattion/vnd.travnoty.v1+json"' do
    get :index

    response.headers['X-Travnoty-Media-Type'].should == "application/vnd.travnoty.v1+json"
  end

  context 'GET #index' do
    it 'it renders the collection of all hubs as json' do
      hubs = create_list(:hub, 3).to_json
      get :index, format: :json

      response.body.should == hubs
    end
  end

  context 'GET #show' do
    it 'renders the requested hub as json' do
      hub = create(:hub, :with_servers, :with_mirrors)
      json = hub.to_json
      get :show, id: hub, format: :json

      response.body.should == json
    end
  end
end
