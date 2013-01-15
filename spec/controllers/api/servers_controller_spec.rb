require 'spec_helper'

describe Api::V1::ServersController do
  describe 'routing' do
    context 'when requesting explicitly for v1' do
      it 'routes api.travnoty.com/servers' do
        { get: 'http://api.lvh.me/servers' }.should route_to("api/v1/servers#index")
      end

      it 'routes api.travnoty.com/servers/:id' do
        { get: 'http://api.lvh.me/servers/1' }.should route_to("api/v1/servers#show", id: '1')
      end

      it 'routes api.travnoty.com/servers/active' do
        { get: 'http://api.lvh.me/servers/active' }.should route_to("api/v1/servers#active")
      end

      it 'routes api.travnoty.com/servers/archived' do
        { get: 'http://api.lvh.me/servers/archived' }.should route_to("api/v1/servers#archived")
      end
    end
  end
end
