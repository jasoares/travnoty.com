require 'spec_helper'

describe Round do
  describe '#hub' do
    before(:each) do
      @server = FactoryGirl.build(:server)
      @round = FactoryGirl.build(:round, server: @server)
    end

    it 'returns the the round\'s server' do
      @round.server.should == @server
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
end
