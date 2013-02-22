require 'spec_helper'

describe Api::V1::ServersController do
  describe 'routing' do
    it 'should set response Content-Type to "applicattion/vnd.travnoty.v1+json"' do
      get :index

      response.content_type.should == "application/vnd.travnoty.v1+json"
    end
  end
end
