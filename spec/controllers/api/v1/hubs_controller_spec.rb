require 'spec_helper'

describe Api::V1::HubsController do
  it 'should set response Content-Type to "applicattion/vnd.travnoty.v1+json"' do
    get :index

    response.headers['X-Travnoty-Media-Type'].should == "application/vnd.travnoty.v1+json"
  end
end
