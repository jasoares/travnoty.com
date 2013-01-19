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

  describe '.servers_not_found', speed: :slow do
    before(:each) do
      FakeDb.load_snapshot 'hubs_detected_servers'
      Travian.hubs[:pt].stub(:servers => [])
    end

    it 'should return an array of servers' do
      Updater.servers_not_found.should have(8).servers
    end

    after(:each) { Hub.destroy_all; Server.destroy_all }
  end

  describe '.servers_not_found_from' do
    context 'given the tx3.travian.pt is no longer online' do
      before(:each) do
        @hub = FactoryGirl.create(:hub)
        @server = FactoryGirl.create(:server, name: 'Speed3x', host: 'http://tx3.travian.pt/', code: 'tx3', hub: @hub)
        Travian.hubs[:pt].stub(:servers => [])
      end

      it 'returns an array with only tx3.travian.pt' do
        Updater.servers_not_found_from(@hub).should == [@server]
      end

      after(:each) { Hub.destroy_all; Server.destroy_all }
    end
  end

  describe '.detect_finished_servers' do
    context 'given the tx3.travian.pt is no longer online' do
      before(:each) do
        hub = FactoryGirl.create(:hub)
        server = FactoryGirl.create(:server, name: 'Speed3x', host: 'http://tx3.travian.pt/', code: 'tx3', hub: hub)
        Travian.hubs[:pt].stub(:servers => [])
      end

      it 'changes the end_date of the server to today' do
        expect { Updater.detect_finished_servers }.to change {
          Server.find_by_host('http://tx3.travian.pt/').end_date
        }.from(nil).to(Date.today)
      end

      after(:each) { Hub.destroy_all; Server.destroy_all }
    end
  end

  describe '.detect_finished_servers_from' do
    context 'given the tx3.travian.pt is no longer online' do
      before(:each) do
        @hub = FactoryGirl.create(:hub)
        @server = FactoryGirl.create(:server, name: 'Speed3x', host: 'http://tx3.travian.pt/', code: 'tx3', hub: @hub)
        Travian.hubs[:pt].stub(:servers => [])
      end

      it 'changes the end_date of the server to today' do
        expect { Updater.detect_finished_servers_from(@hub) }.to change {
          Server.find_by_host('http://tx3.travian.pt/').end_date
        }.from(nil).to(Date.today)
      end

      after(:each) { Hub.destroy_all; Server.destroy_all }
    end
  end

  after(:all) { FakeWeb.allow_net_connect = false }
end
