require 'spec_helper'

describe Hub do
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

    it 'should require the protocol' do
      FactoryGirl.build(:hub, host: 'www.travian.com.br').should have_at_least(1).error_on(:host)
    end

    it 'should be of the form "http://x.travian.x[.x]"' do
      FactoryGirl.build(:hub, host: 'http://www.travnoty.com/').should have_at_least(1).error_on(:host)
    end

    it 'requires the last backslash' do
      FactoryGirl.build(:hub, host: 'http://www.travian.com')
    end

    it 'accepts a valid uri' do
      FactoryGirl.build(:hub, host: 'http://www.travian.com.br/').should be_valid
    end
  end

  describe '#code' do
    it 'is required' do
      FactoryGirl.build(:hub, code: '').should have_at_least(1).error_on(:code)
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
