require 'spec_helper'
require 'loader'

describe Loader, online: true do

  describe '.load_hubs' do
    it 'loads all hubs into the database', online: true do
      FakeWeb.allow { expect { Loader.load_hubs }.to change{ Hub.count }.from(0).to(55) }
    end

    after { Hub.delete_all }
  end

  describe '.detect_mirrors' do
    before(:all) do
      FakeDb.load_snapshot 'hubs'
      fake 'www.travian.com'
    end

    it 'should detect 4 mirrors', online: true do
      FakeWeb.allow { expect { Loader.detect_mirrors }.to change{ Hub.where('mirrors_hub_id IS NOT NULL').count }.from(0).to(4) }
    end

    after(:all) do
      Hub.delete_all
      unfake
    end
  end

  describe '.load_servers' do
    before(:all) do
      FakeDb.load_snapshot 'hubs_detected'
      fake 'www.travian.com'
    end

    it 'loads all servers into the database', online: true do
      FakeWeb.allow { expect { Loader.load_servers }.to change { Server.count }.from(0) }
    end

    after(:all) do
      Hub.delete_all
      Server.delete_all
      unfake
    end
  end

  describe '.load_rounds' do
    before(:all) do
      FakeDb.load_snapshot 'hubs_detected_servers'
      fake 'www.travian.com'
    end

    it 'loads all server rounds into the database', online: true do
      FakeWeb.allow { expect { Loader.load_rounds }.to change { Round.count }.from(0).to(Server.count) }
    end

    after(:all) do
      Hub.delete_all
      Server.delete_all
      Round.delete_all
      unfake
    end
  end
end
