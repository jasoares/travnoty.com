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

  describe '#register' do
    it 'is required' do
      FactoryGirl.build(:server, register: nil).should have_at_least(1).error_on(:register)
    end
  end

  describe '#login' do
    it 'is required' do
      FactoryGirl.build(:server, login: nil).should have_at_least(1).error_on(:login)
    end
  end

  describe '.update!' do
    before(:each) do
      @pt_hub = double('Hub', :host => 'http://www.travian.pt/')
    end

    it 'updates the servers table with all servers from portugal when passed the portugal hub' do
      expect { Server.update!(@pt_hub) }.to change { Server.count }.from(0).to(353)
    end
  end
end
