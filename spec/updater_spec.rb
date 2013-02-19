require 'spec_helper'
require 'updater'
require 'travian_proxy'

describe Updater do
  describe '.detect_new_servers' do
    it 'queries the database for the servers returned by TravianLoader' do
      TravianLoader.stub(servers: [double('Server', host: 'ts1.travian.net')])
      Server.should_receive(:exists?).with(host: 'ts1.travian.net').and_return(true)
      Updater.detect_new_servers
    end

    it 'does not change the database when no new servers exist' do
      TravianLoader.stub(servers: [])
      expect { Updater.detect_new_servers }.not_to change { Server.count }
    end

    it 'calls Updater.add_server when there is a new server' do
      server = double('Travian::Server', host: 'ts1.travian.net')
      TravianLoader.stub(servers: [server])
      Server.stub(:exists? => false)
      Updater.should_receive(:add_server).with(server)
      Updater.detect_new_servers
    end
  end

  describe '.detect_ended_rounds' do
    let(:round)  { stub_model(Round, server: stub_model(Server)) }
    let(:server) { double('Travian::Server') }

    before { Round.stub_chain(:includes, :running).and_return([round]) }

    it 'queries all running rounds requiring servers' do
      partial_arel = Round.includes(:server)
      Round.should_receive(:includes).with(:server).and_return(partial_arel)
      partial_arel.should_receive(:running).and_return([])
      Updater.detect_ended_rounds
    end

    it 'calls Updater.end_round if the server is ended' do
      server.stub(ended?: true)
      TravianLoader.stub(:Server => server)
      Updater.should_receive(:end_round).with(round)
      Updater.detect_ended_rounds
    end

    it 'does not call Updater.end_round if the server is not ended' do
      server.stub(ended?: false)
      TravianLoader.stub(:Server => server)
      Updater.should_not_receive(:end_round).with(round)
      Updater.detect_ended_rounds
    end
  end

  describe '.detect_new_rounds' do
    let(:server_record) { stub_model(Server, host: 'ts1.travian.net')}
    let(:server) { double('Travian::Server') }

    before do
      Server.stub(:ended).and_return([server_record])
      TravianLoader.stub(:Server => server)
    end

    it 'calls Updater.add_round if the server is restarting' do
      server.stub(restarting?: true)
      Updater.should_receive(:add_round).with(server, server_record)
      Updater.detect_new_rounds
    end

    it 'does not call Updater.add_round if the server is not restarting' do
      server.stub(restarting?: false)
      Updater.should_not_receive(:add_round)
      Updater.detect_new_rounds
    end

    context 'when a Travian::ConnectionTimeout is raised' do
      let(:host) { 'finals.travian.com' }
      let(:trace) { 'Timeout::Error' }
      let(:server1) { stub_model(Server, host: 'finals.travian.com') }
      let(:server2) { stub_model(Server, host: 'ts1.travian.com') }
      let(:round1) { double('Travian::Server1', host: 'finals.travian.com') }
      let(:round2) { double('Travian::Server2', host: 'ts1.travian.com', restarting?: false) }

      before do
        Server.stub(:ended).and_return([server1, server2])
        TravianLoader.stub(:Server) do |server|
          next round1 if server.host == server1.host
          next round2 if server.host == server2.host
        end
        round1.stub(:restarting?).and_raise(Travian::ConnectionTimeout.new(host, trace))
      end

      it 'rescues the exception and continues on the next server' do
        round2.should_receive(:restarting?).and_return(false)
        Updater.detect_new_rounds
      end
      it 'logs the exception' do
        message = "[TravianUpdater:#{DateTime.now}][Warning] Error connecting to '#{host}' (#{trace})"
        Rails.logger.should_receive(:warn).with(message)
        Updater.detect_new_rounds
      end
    end
  end

  describe '.add_server' do
    let(:attributes) { { code: 'ts1', host: 'ts1.travian.net', name: 'Servidor 1', speed: 1, world_id: 'net11' } }
    let(:hub_code) { 'net' }
    let(:server) { double('Travian::Server', attributes: attributes, host: attributes[:host], hub_code: hub_code, )}

    it 'adds the server to its hub using server.hub_code and server.attributes' do
      server.should_receive(:hub_code).and_return(hub_code)
      server.should_receive(:attributes).and_return(attributes)
      hub = stub_model(Hub)
      hub.should_receive(:servers).and_return(servers = [])
      Hub.should_receive(:find_by_code).with('net').and_return(hub)
      server_record = stub_model(Server)
      Server.should_receive(:new).with(attributes).and_return(server_record)
      servers.should_receive(:<<).with(server_record)
      Updater.send :add_server, server
    end

    it 'calls log with "Added the new server ts1.travian.net" when a server is added' do
      Hub.stub_chain(:find_by_code, :servers, :<<).and_return(true)
      Server.stub(:new)
      Updater.should_receive(:log).with("Server ts1.travian.net added.")
      Updater.send :add_server, server
    end

    it 'does not call log if the server fails validations' do
      Hub.stub_chain(:find_by_code, :servers, :<<).and_return(false)
      Server.stub(:new)
      Updater.should_not_receive(:log)
      Updater.send :add_server, server
    end
  end

  describe '.add_round' do
    it 'adds the round to its server' do
      round = double('Server')
      round.should_receive(:restart_date).twice.and_return(DateTime.new(2012,12,4))
      round.should_receive(:version).and_return('4.0')
      server_record = stub_model(Server, host: 'ts1.travian.net')
      server_record.should_receive(:rounds).and_return(rounds = [])
      rounds.should_receive(:<<).with(kind_of(Round))
      Updater.send :add_round, round, server_record
    end

    it 'calls log with "There is a new round starting on 2013-02-22T06:00:00+04:00 for ts1.travian.net added."' do
      attributes = { code: 'ts1', host: 'ts1.travian.net', name: 'Servidor 1', speed: 1, world_id: 'net11' }
      round = double('Server', restart_date: DateTime.new(2013,2,22,6,0,0,"+04:00"), version: '4.0')
      server_record = stub_model(Server, host: 'ts1.travian.net')
      Updater.should_receive(:log).with("Restarting round on 2013-02-22T06:00:00+04:00 for ts1.travian.net added.")
      Updater.send :add_round, round, server_record
    end
  end

  describe '.end_round' do
    let(:round) { stub_model(Round, server: stub_model(Server, host: 'ts1.travian.net')) }

    it 'sets the end_date attribute of the passed round' do
      round.should_receive(:update_attributes).with(end_date: Date.today.to_datetime)
      Updater.send :end_round, round
    end

    it 'calls log with "Current round ended for server ts1.travian.net" when it passes validations' do
      round.stub(:update_attributes).and_return(true)
      Updater.should_receive(:log).with("Current round ended for server ts1.travian.net")
      Updater.send :end_round, round
    end

    it 'does not call log when validations fail' do
      round.stub(:update_attributes).and_return(false)
      Updater.should_not_receive(:log)
      Updater.send :end_round, round
    end
  end

  describe '.log' do
    it 'calls Rails.logger.info with "[TravianUpdater:<timestamp>] <message>"' do
      message = "Current round ended for server ts1.travian.net"
      Rails.logger.should_receive(:info).with("[TravianUpdater:#{DateTime.now}] #{message}")
      Updater.send :log, message
    end
  end

  describe '.warn' do
    it 'calls Rails.logger.warn with "[TravianUpdater:<timestamp>][Warning] <message>"' do
      message = "Error connecting to 'finals.travian.com' (Timeout::Error)"
      Rails.logger.should_receive(:warn).with("[TravianUpdater:#{DateTime.now}][Warning] #{message}")
      Updater.send :warn, message
    end
  end
end
