require 'spec_helper'
require 'loader'

describe Loader, online: true do

  describe '.load_hubs' do
    let(:procedure) { lambda { Loader.load_hubs } }
    it 'loads all hubs into the database', speed: :slow do
      FakeWeb.allow { expect { Loader.load_hubs }.to change{ Hub.count }.from(0).to(55) }
    end

    after { Hub.destroy_all }
  end

  describe '.detect_mirrors' do
    fake 'www.travian.com'
    before { FakeDb.load_snapshot 'hubs' }
    let(:procedure) { lambda { Loader.detect_mirrors } }

    it 'should detect 4 mirrors', speed: :slow do
      FakeWeb.allow { expect { Loader.detect_mirrors }.to change{ Hub.where('mirrors_hub_id IS NOT NULL').count }.from(0).to(4) }
    end

    after(:all) { Hub.delete_all }
  end

  describe '.load_servers' do
    fake 'www.travian.com'
    before { FakeDb.load_snapshot 'hubs_detected' }
    let(:procedure) { lambda { Loader.load_servers } }

    it 'loads all servers into the database', speed: :slow do
      FakeWeb.allow { expect { Loader.load_servers }.to change { Server.count }.from(0) }
    end

    after(:all) { Hub.delete_all; Server.delete_all }
  end

  describe '.load_rounds', online: true do
    fake 'www.travian.com'
    before { FakeDb.load_snapshot 'hubs_detected_servers' }

    it 'loads all server rounds into the database' do
      FakeWeb.allow { expect { Loader.load_rounds }.to change { Round.count }.from(0).to(Server.count) }
    end
  end

end
