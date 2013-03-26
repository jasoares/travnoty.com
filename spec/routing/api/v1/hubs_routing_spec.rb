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

  it 'GET /hubs/:id/supported_servers' do
    { get: "#{url}/hubs/1/supported_servers" }.should route_to action :supported_servers, id: '1'
  end

end
