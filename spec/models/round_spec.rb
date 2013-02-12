require 'spec_helper'

describe Round do
  describe '#running?' do
    it 'returns true if the start_date is in the past and there is no end_date' do
      FactoryGirl.build(:running_round).should be_running
    end

    it 'returns false if the start_date is in the future' do
      FactoryGirl.build(:restarting_round).should_not be_running
    end

    it 'returns false if the end_date is not nil' do
      FactoryGirl.build(:ended_round).should_not be_running
    end
  end

  describe '#restarting?' do
    it 'returns true if the start_date is in the future' do
      FactoryGirl.build(:restarting_round).should be_restarting
    end

    it 'returns false if the start_date is in the past' do
      FactoryGirl.build(:running_round).should_not be_restarting
    end
  end

  describe '#ended?' do
    it 'returns true if the end_date is set' do
      FactoryGirl.build(:ended_round).should be_ended
    end

    it 'returns false if the start_date is in the past and the end_date is nil' do
      FactoryGirl.build(:running_round).should_not be_ended
    end
  end

  describe '#start_date' do
    it 'is required' do
      FactoryGirl.build(:round).should have_at_least(1).error_on(:start_date)
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
      current_round = FactoryGirl.create(:running_round)
      FactoryGirl.create(:ended_round)
      Round.latest.should == current_round
    end

    after(:each) { Round.delete_all }
  end

  describe '.ended' do
    let(:server) { FactoryGirl.create(:server) }

    it 'returns a Round with its server id when all rounds end_date is set' do
      server.rounds << FactoryGirl.create(:ended_round)
      server.rounds << FactoryGirl.create(:ended_round)
      Round.ended.first.server_id.should == server.id
    end

    it 'returns no round with server id when at least one round is not ended' do
      server.rounds << FactoryGirl.create(:running_round)
      server.rounds << FactoryGirl.create(:ended_round)
      Round.ended.should == []
    end

    after(:each) { Server.delete_all; Round.delete_all }
  end

  describe '.restarting' do
    it 'returns the rounds with start_date in the future' do
      FactoryGirl.create(:running_round)
      future_round = FactoryGirl.create(:restarting_round)
      Round.restarting.should == [future_round]
    end

    after(:each) { Round.delete_all }
  end

  describe '.running' do
    it 'returns all rounds which start_date is in the past and end_date is null' do
      running_round = FactoryGirl.create(:running_round)
      FactoryGirl.create(:restarting_round)
      FactoryGirl.create(:ended_round)
      Round.running.should == [running_round]
    end

    after(:each) { Round.delete_all }
  end
end
