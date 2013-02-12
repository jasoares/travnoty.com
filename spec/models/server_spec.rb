require 'spec_helper'

describe Server do
  let(:server) { FactoryGirl.build(:server) }
  let(:ended_round) { FactoryGirl.build(:ended_round) }
  let(:archived_round) { FactoryGirl.build(:archived_round) }
  let(:running_round) { FactoryGirl.build(:running_round) }
  let(:restarting_round) { FactoryGirl.build(:restarting_round) }

  it 'should be valid' do
    server.should be_valid
  end

  describe '#current_round' do
    before(:all) { Timecop.freeze(Time.new(2013,2,8)) }

    context 'given a server with an ended and a running round' do
      before(:each) do
        server.rounds += [ended_round, running_round]
        server.save
      end

      it 'returns the current not ended round' do
        server.current_round.should == running_round
      end

      after(:each) { Server.delete_all }
    end

    context 'given there is no running round' do
      before(:each) do
        server.rounds += [ended_round, archived_round]
        server.save
      end

      it 'returns the last ended round' do
        server.current_round.should == ended_round
      end

      after(:each) { Server.delete_all }
    end

    after(:all) { Timecop.return }
  end

  describe '#running?' do
    it 'calls #running? on the current_round return value' do
      round = double('Round')
      round.should_receive(:running?).and_return(true)
      server.should_receive(:current_round).and_return(round)
      server.running?
    end
  end

  describe '#ended?' do
    it 'calls #ended? on the current_round return value' do
      round = double('Round')
      round.should_receive(:ended?).and_return(true)
      server.should_receive(:current_round).and_return(round)
      server.ended?
    end
  end

  describe '#restarting?' do
    it 'calls #restarting? on the current_round return value' do
      round = double('Round')
      round.should_receive(:restarting?).and_return(true)
      server.should_receive(:current_round).and_return(round)
      server.restarting?
    end
  end

  describe '#host' do
    it 'is required' do
      FactoryGirl.build(:server, host: '').should have_at_least(1).error_on(:host)
    end

    it 'should be unique' do
      FactoryGirl.create(:hub, host: 'ts1.travian.net')
      FactoryGirl.build(:hub, host: 'ts1.travian.net').should have_at_least(1).error_on(:host)
      Hub.delete_all
    end

    it 'should not accept the protocol' do
      FactoryGirl.build(:server, host: 'http://ts1.travian.com.br').should have_at_least(1).error_on(:host)
    end

    it 'should be of the form "\w+.travian.\w+(?:\.\w+)?"' do
      FactoryGirl.build(:server, host: 'ts3.travnoty.com').should have_at_least(1).error_on(:host)
    end

    it 'should not have neither the path or the last backslash' do
      FactoryGirl.build(:server, host: 'ts1.travian.com/').should have_at_least(1).error_on(:host)
    end

    it 'accepts a valid host' do
      FactoryGirl.build(:hub, host: 'tx4.travian.com.br').should be_valid
    end
  end

  describe '#speed' do
    it 'is required' do
      FactoryGirl.build(:server, speed: nil).should have_at_least(1).error_on(:speed)
    end

    it 'should be an integer' do
      FactoryGirl.build(:server, speed: 'x3').should have_at_least(1).error_on(:speed)
    end
  end
end
