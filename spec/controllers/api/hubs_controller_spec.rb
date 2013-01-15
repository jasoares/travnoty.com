require 'spec_helper'

describe Api::V1::HubsController do
  describe 'routing' do
    it 'routes api.travnoty.com/hubs' do
      { get: 'http://api.lvh.me/hubs' }.should route_to("api/v1/hubs#index")
    end

    it 'routes api.travnoty.com/hubs/:id' do
      { get: 'http://api.lvh.me/hubs/1' }.should route_to("api/v1/hubs#show", id: '1')
    end

    it 'routes api.travnoty.com/hubs/:id/servers' do
      { get: 'http://api.lvh.me/hubs/1/servers' }.should route_to("api/v1/hubs#servers", id: '1')
    end

    it 'routes api.travnoty.com/hubs/:id/active_servers' do
      { get: 'http://api.lvh.me/hubs/1/active_servers' }.should route_to("api/v1/hubs#active_servers", id: '1')
    end

    it 'routes api.travnoty.com/hubs/:id/archived_servers' do
      { get: 'http://api.lvh.me/hubs/1/archived_servers' }.should route_to("api/v1/hubs#archived_servers", id: '1')
    end
  end
end
