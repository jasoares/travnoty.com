require 'spec_helper'

describe Hub do
  it 'should be valid' do
    build(:hub).should be_valid
  end

  describe '#name' do
    it 'is required' do
      build(:hub, name: '').should have_at_least(1).error_on(:name)
    end
  end

  describe '#host' do
    it 'is required' do
      build(:hub, host: '').should have_at_least(1).error_on(:host)
    end

    it 'should be unique' do
      create(:hub, host: 'www.travian.net')
      build(:hub, host: 'www.travian.net').should have_at_least(1).error_on(:host)
    end

    it 'should be unique regardless of case' do
      create(:hub, host: 'www.travian.NET')
      build(:hub, host: 'www.travian.net').should have_at_least(1).error_on(:host)
    end

    it 'should not accept a host with the protocol' do
      build(:hub, host: 'http://www.travian.com.br').should have_at_least(1).error_on(:host)
    end

    it 'should be of the form "\w+.travian.\w+(?:\.\w+)?"' do
      build(:hub, host: 'www.travnoty.com').should have_at_least(1).error_on(:host)
    end

    it 'should not accept a host with the last backslash' do
      build(:hub, host: 'www.travian.com/').should have_at_least(1).error_on(:host)
    end

    it 'accepts a valid host' do
      build(:hub, host: 'www.travian.com.br').should be_valid
    end
  end

  describe '#code' do
    it 'is required' do
      build(:hub, code: '').should have_at_least(1).error_on(:code)
    end

    it 'should be unique' do
      create(:hub, code: 'it')
      build(:hub, code: 'it').should have_at_least(1).error_on(:code)
    end

    it 'should not accept codes with length smaller than 2' do
      build(:hub, code: 'P').should have_at_least(1).error_on(:code)
    end

    it 'should not accept numbers' do
      build(:hub, code: 'W3').should have_at_least(1).error_on(:code)
    end

    it 'should accept up to 6 letters for bigger codes like "arabia"' do
      build(:hub, code: 'arabia').should be_valid
    end
  end

  describe '#language' do
    it 'is required' do
      build(:hub, language: '').should have_at_least(1).error_on(:language)
    end

    it 'should not accept a language with length smaller than 2' do
      build(:hub, language: 'p').should have_at_least(1).error_on(:language)
    end
  end

  describe '#servers' do
    context 'when called on a mirror' do
      before(:each) do
        @main_hub = create(:hub)
        @main_hub.servers << build(:server)
        @hub = build(:hub, mirrors_hub_id: @main_hub.id)
      end

      it 'returns the server list of it\'s main hub' do
        @hub.servers.should == @main_hub.servers
      end
    end

    context 'when called on a main hub' do
      before(:each) do
        @main_hub = create(:hub)
        @main_hub.servers << build(:server)
      end

      it 'returns it\'s server list' do
        Hub.first.servers.should == @main_hub.servers
      end
    end
  end

  describe '#mirror?' do
    after(:each) { Hub.delete_all }

    it 'returns true when called on a mirror hub' do
      create(:mirror_hub).mirror?.should be true
    end

    it 'returns false when called on a main hub' do
      build(:main_hub).mirror?.should be false
    end
  end
end
