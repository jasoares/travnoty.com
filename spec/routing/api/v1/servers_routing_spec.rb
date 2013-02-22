require 'spec_helper'

describe 'Api::V1::ServersRoutes' do
  def action(action, params={})
    { controller: 'api/v1/servers', format: :json, action: action.to_s }.merge(params)
  end

  let(:url) { 'http://api.lvh.me' }

  it 'GET /servers' do
    { get: "#{url}/servers" }.should route_to action :index
  end

  it 'GET /servers/:id' do
    { get: "#{url}/servers/1" }.should route_to action :show, id: '1'
  end

  it 'GET /servers/active' do
    { get: "#{url}/servers/active" }.should route_to action :active
  end

  it 'GET /servers/archived' do
    { get: "#{url}/servers/archived" }.should route_to action :archived
  end

end
