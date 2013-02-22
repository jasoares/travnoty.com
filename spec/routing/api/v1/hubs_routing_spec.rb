require 'spec_helper'

describe 'Api::V1::HubsRouting' do
  def action(action, params={})
    { controller: 'api/v1/hubs', format: :json, action: action.to_s }.merge(params)
  end

  let(:url) { 'http://api.lvh.me' }

  it 'GET /hubs' do
    { get: "#{url}/hubs" }.should route_to action :index
  end

  it 'GET /hubs/:id' do
    { get: "#{url}/hubs/1" }.should route_to action :show, id: '1'
  end

  it 'GET /hubs/:id/servers' do
    { get: "#{url}/hubs/1/servers" }.should route_to action :servers, id: '1'
  end

  it 'GET /hubs/:id/active_servers' do
    { get: "#{url}/hubs/1/active_servers" }.should route_to action :active_servers, id: '1'
  end

  it 'GET /hubs/:id/archived_servers' do
    { get: "#{url}/hubs/1/archived_servers" }.should route_to action :archived_servers, id: '1'
  end

end
