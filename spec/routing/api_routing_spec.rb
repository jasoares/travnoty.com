require 'spec_helper'

describe Api do
  describe 'routing' do
    it 'should not route travnoty.com/hubs' do
      { get: 'http://lvh.me/hubs' }.should_not be_routable
    end

    it 'should not route travnoty.com/servers' do
      { get: 'http://lvh.me/hubs' }.should_not be_routable
    end
  end
end
