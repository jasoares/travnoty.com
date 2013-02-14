require 'spec_helper'

describe Server do
  it { build_stubbed(:server).should be_valid }

  describe '#host' do
    it 'is required' do
      expect(build(:server, host: '').errors_on(:host)).to include("can't be blank")
    end

    it 'should be unique' do
      create(:server, host: 'ts1.travian.net')
      expect(build(:server, host: 'ts1.travian.net').errors_on(:host)).to include("has already been taken")
    end

    it 'should not accept the protocol' do
      expect(build(:server, host: 'http://ts1.travian.com.br').errors_on(:host)).to include("is not a valid travian host")
    end

    it 'should be of the form "\w+.travian.\w+(?:\.\w+)?"' do
      expect(build(:server, host: 'ts3.travnoty.com').errors_on(:host)).to include("is not a valid travian host")
    end

    it 'should not have neither the path or the last backslash' do
      expect(build(:server, host: 'ts1.travian.com/').errors_on(:host)).to include("is not a valid travian host")
    end

    it 'accepts a valid host' do
      expect(build(:server, host: 'tx4.travian.com.br')).to be_valid
    end
  end

  describe '#rounds' do
    it 'should return a list of rounds ordered by start date from newer to older' do
      server = create(:server_with_rounds)
      server.rounds.each_slice(2).all? { |r1,r2| r1.start_date > r2.start_date }.should be true
    end
  end

  describe '#speed' do
    it 'is required' do
      build(:server, speed: nil).should have_at_least(1).error_on(:speed)
    end

    it 'should be an integer' do
      build(:server, speed: 'x3').should have_at_least(1).error_on(:speed)
    end

    it 'should not accept a speed of 0' do
      build(:server, speed: 0).should have_at_least(1).error_on(:speed)
    end
  end

  describe '#url' do
    it 'returns the host prefixed with the protocol "http://"' do
      build_stubbed(:server, host: 'ts1.travian.com').url.should == "http://ts1.travian.com"
    end
  end
end
