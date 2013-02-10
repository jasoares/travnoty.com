require 'spec_helper'

describe Round do
  before(:all) { Round.observers.disable :all }

  describe '#running?' do
    it 'returns true if the start_date is in the past and there is no end_date' do
      FactoryGirl.build(:round, start_date: (Date.today - 5).to_datetime).should be_running
    end

    it 'returns false if the start_date is in the future' do
      FactoryGirl.build(:round, start_date: (Date.today + 2).to_datetime).should_not be_running
    end

    it 'returns false if the end_date is not nil' do
      FactoryGirl.build(:round, end_date: (Date.today - 1).to_datetime).should_not be_running
    end
  end

  describe '#restarting?' do
    it 'returns true if the start_date is in the future' do
      FactoryGirl.build(:round, start_date: (Date.today + 2).to_datetime).should be_restarting
    end

    it 'returns false if the start_date is in the past' do
      FactoryGirl.build(:round).should_not be_restarting
    end
  end

  describe '#ended?' do
    it 'returns true if the end_date is set' do
      FactoryGirl.build(:round, end_date: Date.today.to_datetime).should be_ended
    end

    it 'returns false if the start_date is in the past and the end_date is nil' do
      FactoryGirl.build(:round).should_not be_ended
    end
  end

  describe '#start_date' do
    it 'is required' do
      FactoryGirl.build(:round, start_date: nil).should have_at_least(1).error_on(:start_date)
    end
  end

  describe '#version' do
    it 'is required' do
      FactoryGirl.build(:round, version: '').should have_at_least(1).error_on(:version)
    end

    it 'should be in format "\d.\d[.\d]"' do
      FactoryGirl.build(:round, version: '12').should have_at_least(1).error_on(:version)
    end
  end

  describe '.latest' do
    it 'returns the first round when ordered by start_date' do
      current_round = FactoryGirl.create(:round, start_date: DateTime.new(2012,12,8))
      old_round = FactoryGirl.create(:round, start_date: DateTime.new(2011,12,25), end_date: DateTime.new(2012,11,2))
      Round.latest.should == current_round
    end

    after(:each) { Round.delete_all }
  end

  describe '.ended' do
    let(:server) { FactoryGirl.create(:server) }

    it 'returns a Round with its server id when all rounds end_date is set' do
      server.rounds << FactoryGirl.create(:round, end_date: DateTime.now)
      server.rounds << FactoryGirl.create(:round, end_date: DateTime.now)
      Round.ended.first.server_id.should == server.id
    end

    it 'returns no round with server id when at least one round is not ended' do
      server.rounds << FactoryGirl.create(:round)
      server.rounds << FactoryGirl.create(:round, start_date: DateTime.now - 5, end_date: DateTime.now)
      Round.ended.should == []
    end

    after(:each) { Server.delete_all; Round.delete_all }
  end

  describe '.restarting' do
    before(:all) { Timecop.freeze(Time.utc(2013,2,10)) }

    it 'returns the rounds with start_date in the future' do
      FactoryGirl.create(:round)
      future_round = FactoryGirl.create(:round, start_date: DateTime.now + 5)
      Round.restarting.should == [future_round]
    end

    after(:each) { Round.delete_all }
    after(:all) { Timecop.return }
  end

  describe '.running' do
    it 'returns all rounds which start_date is in the past and end_date is null' do
      running_round = FactoryGirl.create(:round)
      FactoryGirl.create(:round, start_date: DateTime.now + 5)
      FactoryGirl.create(:round, end_date: DateTime.now)
      Round.running.should == [running_round]
    end

    after(:each) { Round.delete_all }
  end

  after(:all) { Round.observers.enable :all }
end
