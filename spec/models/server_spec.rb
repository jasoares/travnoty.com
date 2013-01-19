require 'spec_helper'

describe Server do
  let(:server) { FactoryGirl.build(:server) }

  it 'should be valid' do
    server.should be_valid
  end

  describe '#host' do
    it 'is required' do
      FactoryGirl.build(:server, host: '').should have_at_least(1).error_on(:host)
    end

    it 'should require the protocol' do
      FactoryGirl.build(:server, host: 'www.travian.com.br').should have_at_least(1).error_on(:host)
    end

    it 'should be of the form "http://x.travian.x[.x]"' do
      FactoryGirl.build(:server, host: 'http://www.travnoty.com/').should have_at_least(1).error_on(:host)
    end

    it 'requires the last backslash' do
      FactoryGirl.build(:server, host: 'http://www.travian.com')
    end

    it 'accepts a valid uri' do
      FactoryGirl.build(:server, host: 'http://www.travian.com.br/').should be_valid
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

  describe '#start_date' do
    it 'is required' do
      FactoryGirl.build(:server, start_date: nil).should have_at_least(1).error_on(:start_date)
    end
  end

  describe '#version' do
    it 'is required' do
      FactoryGirl.build(:server, version: '').should have_at_least(1).error_on(:version)
    end

    it 'should be in format "\d.\d[.\d]"' do
      FactoryGirl.build(:server, version: '12').should have_at_least(1).error_on(:version)
    end
  end

  describe '#world_id' do
    it 'is required' do
      FactoryGirl.build(:server, world_id: '').should have_at_least(1).error_on(:world_id)
    end
  end

  shared_context 'active and archived servers' do
    before(:all) do
      @active = FactoryGirl.create(:server)
      @archived = FactoryGirl.create(:server, end_date: 5.days.ago)
    end

    after(:all) do
      Server.destroy_all
    end
  end

  describe '.active' do
    include_context 'active and archived servers'
    it 'should return only serves with end_date equal to nil' do
      Server.active.should == [@active]
    end
  end

  describe '.archived' do
    include_context 'active and archived servers'
    it 'should return only servers with end_data different from nil' do
      Server.archived.should == [@archived]
    end
  end
end
