require 'spec_helper'

describe Round do
  describe '#running?' do
    it 'returns true if the start_date is in the past and there is no end_date' do
      build(:running_round).should be_running
    end

    it 'returns false if the start_date is in the future' do
      build(:restarting_round).should_not be_running
    end

    it 'returns false if the end_date is not nil' do
      build(:ended_round).should_not be_running
    end
  end

  describe '#restarting?' do
    it 'returns true if the start_date is in the future' do
      build(:restarting_round).should be_restarting
    end

    it 'returns false if the start_date is in the past' do
      build(:running_round).should_not be_restarting
    end
  end

  describe '#ended?' do
    it 'returns true if the end_date is set' do
      build(:ended_round).should be_ended
    end

    it 'returns false if the start_date is in the past and the end_date is nil' do
      build(:running_round).should_not be_ended
    end
  end

  describe '#start_date' do
    it 'is required' do
      build(:round).should have_at_least(1).error_on(:start_date)
    end

    it 'should be older than the end date when there is one' do
      round = build(:round, start_date: 300.days.ago.to_datetime, end_date: 1.year.ago.to_datetime)
      expect(round.errors_on(:start_date)).to include('must be before the end date')
    end

    it 'should be unique when scoped per server' do
      server = create(:server)
      server.rounds << build(:round, start_date: DateTime.new(2013,2,14))
      round = build(:round, start_date: DateTime.new(2013,2,14))
      server.rounds << round
      expect(round.errors_on(:start_date)).to include('has already been taken')
    end
  end

  describe '#end_date' do
    it 'should be newer than start_date when provided' do
      round = build(:round, start_date: 300.days.ago.to_datetime, end_date: 1.year.ago.to_datetime)
      expect(round.errors_on(:end_date)).to include('must be after the start date')
    end

    it 'should be unique when scoped per server' do
      server = create(:server)
      server.rounds << build(:round, start_date: DateTime.new(2011,2,14), end_date: DateTime.new(2013,2,1))
      round = build(:round, start_date: DateTime.new(2012,2,14), end_date: DateTime.new(2013,2,1))
      server.rounds << round
      expect(round.errors_on(:end_date)).to include('has already been taken')
    end

    it 'should be unique including nil values' do
      server = create(:server)
      server.rounds << build(:round, start_date: DateTime.new(2011,2,14), end_date: nil)
      round = build(:round, start_date: DateTime.new(2012,2,14), end_date: nil)
      server.rounds << round
      expect(round.errors_on(:end_date)).to include('has already been taken')
    end
  end

  describe '#version' do
    it 'is required' do
      build(:round, version: '').should have_at_least(1).error_on(:version)
    end

    it 'should be in format "\d.\d[.\d]"' do
      build(:round, version: '12').should have_at_least(1).error_on(:version)
    end
  end

  describe '.ended' do
    let(:server) { create(:server) }

    it 'returns a Round with its server id when all rounds end_date is set' do
      server.rounds << create(:ended_round)
      server.rounds << create(:ended_round)
      Round.ended.first.server_id.should == server.id
    end

    it 'returns no round with server id when at least one round is not ended' do
      server.rounds << create(:running_round)
      server.rounds << create(:ended_round)
      Round.ended.should == []
    end
  end

  describe '.restarting' do
    it 'returns the rounds with start_date in the future' do
      create(:ended_round)
      future_round = create(:restarting_round)
      Round.restarting.should == [future_round]
    end
  end

  describe '.running' do
    it 'returns all rounds which start_date is in the past and end_date is null' do
      running_round = create(:running_round)
      create(:ended_round)
      Round.running.should == [running_round]
    end
  end
end
