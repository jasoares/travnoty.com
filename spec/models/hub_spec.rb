require 'spec_helper'

describe Hub do
  context 'given a sample hub record' do
    let(:hub) { FactoryGirl.build(:hub) }

    it 'should be valid' do
      hub.should be_valid
    end

    describe '#name' do
      it 'is required' do
        FactoryGirl.build(:hub, name: '').should have_at_least(1).error_on(:name)
      end
    end

    describe '#host' do
      it 'is required' do
        FactoryGirl.build(:hub, host: '').should have_at_least(1).error_on(:host)
      end

      it 'should be unique' do
        FactoryGirl.create(:hub, host: 'http://www.travian.net/')
        FactoryGirl.build(:hub, host: 'http://www.travian.NET/').should have_at_least(1).error_on(:host)
      end

      it 'should require the protocol' do
        FactoryGirl.build(:hub, host: 'www.travian.com.br').should have_at_least(1).error_on(:host)
      end

      it 'should be of the form "http://x.travian.x[.x]"' do
        FactoryGirl.build(:hub, host: 'http://www.travnoty.com/').should have_at_least(1).error_on(:host)
      end

      it 'requires the last backslash' do
        FactoryGirl.build(:hub, host: 'http://www.travian.com').should have_at_least(1).error_on(:host)
      end

      it 'accepts a valid uri' do
        FactoryGirl.build(:hub, host: 'http://www.travian.com.br/').should be_valid
      end
    end

    describe '#code' do
      it 'is required' do
        FactoryGirl.build(:hub, code: '').should have_at_least(1).error_on(:code)
      end

      it 'should be unique' do
        FactoryGirl.create(:hub, code: 'it')
        FactoryGirl.build(:hub, code: 'it').should have_at_least(1).error_on(:code)
      end

      it 'should not accept codes with length smaller than 2' do
        FactoryGirl.build(:hub, code: 'P').should have_at_least(1).error_on(:code)
      end

      it 'should not accept numbers' do
        FactoryGirl.build(:hub, code: 'W3').should have_at_least(1).error_on(:code)
      end

      it 'should accept up to 6 letters for bigger codes like "arabia"' do
        FactoryGirl.build(:hub, code: 'arabia').should be_valid
      end
    end
  end

  describe '.update!' do
    it 'delegates to Hub.fetch_list! to fetch data' do
      Hub.should_receive(:fetch_list!).once.and_return('pt' => {'code' => :pt, 'host' => 'http://www.travian.pt/', 'name' => 'Portugal'})
      Hub.update!
    end

    it 'updates the hubs table with all travian hubs' do
      expect { Hub.update! }.to change { Hub.count }.from(0).to(55)
    end
  end
end
