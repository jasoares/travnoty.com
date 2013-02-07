require 'spec_helper'

describe Server do
  let(:server) { FactoryGirl.build(:server) }

  it 'should be valid' do
    server.should be_valid
  end

  describe '#round' do
    before(:each) do
      @round = FactoryGirl.build(:round)
      server.rounds << @round
    end

    it 'returns the rounds of the server' do
      server.rounds.should == [@round]
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

  describe '#world_id' do
    it 'is required' do
      FactoryGirl.build(:server, world_id: '').should have_at_least(1).error_on(:world_id)
    end
  end
end
