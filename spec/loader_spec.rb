require 'spec_helper'
require 'loader'

describe Loader, online: true do

  shared_examples_for 'a reporter', speed: :normal do
    it 'does not raise an exception when hub connection fails' do
      expect { procedure.call }.to_not raise_error
    end
  end

  describe '.load_hubs' do
    let(:procedure) { lambda { Loader.load_hubs } }
    it 'loads all hubs into the database', speed: :slow do
      FakeWeb.allow { expect { Loader.load_hubs }.to change{ Hub.count }.from(0).to(55) }
    end

    it_behaves_like 'a reporter'

    after { Hub.destroy_all }
  end

  describe '.detect_mirrors' do
    fake 'www.travian.com'
    before { FakeDb.load_snapshot 'hubs' }
    let(:procedure) { lambda { Loader.detect_mirrors } }

    it 'should detect 4 mirrors', speed: :slow do
      FakeWeb.allow { expect { Loader.detect_mirrors }.to change{ Hub.where('mirrors_hub_id IS NOT NULL').count }.from(0).to(4) }
    end

    it_behaves_like 'a reporter'

    after { Hub.destroy_all }
  end

  describe '.load_servers' do
    fake 'www.travian.com'
    before { FakeDb.load_snapshot 'hubs_detected' }
    let(:procedure) { lambda { Loader.load_servers } }

    it 'loads all servers into the database', speed: :slow do
      FakeWeb.allow { expect { Loader.load_servers }.to change { Server.count }.from(0) }
    end

    it_behaves_like 'a reporter'

    after { Server.destroy_all }
  end
end
