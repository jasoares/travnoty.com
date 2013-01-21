require 'spec_helper'
require 'updater'

describe Updater, online: true do
  before(:all) { FakeWeb.allow_net_connect = true }

  describe '.detect_new_servers' do
    it 'calls .detect_new_servers_from one time for each hub' do
      Updater.should_receive(:detect_new_servers_from).exactly(Hub.main_hubs.count).times
      Updater.detect_new_servers
    end
  end

  describe '.detect_new_servers_from' do
    let(:hub) { FactoryGirl.build(:hub) }

    it 'should delegate data fetching to Travian gem' do
      Travian.hubs[:pt].should_receive(:servers) { [] }
      Updater.detect_new_servers_from(hub)
    end

    context 'given the database does not have the server tx3.travian.pt' do
      before(:each) do
        Travian.hubs[:pt].stub(:servers => [Travian.hubs[:pt].servers[:tx3]])
        @hub = FactoryGirl.create(:hub)
      end

      it 'should add the new server to the database' do
        expect { Updater.detect_new_servers_from(@hub) }.to change {
          @hub.servers.count
        }.from(0).to(1)
      end
    end
  end

  after(:all) { FakeWeb.allow_net_connect = false }
end
