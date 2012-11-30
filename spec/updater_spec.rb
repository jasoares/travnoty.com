require 'updater'
require 'spec_helper'

describe Updater do
  describe 'load_hubs!' do
    it 'returns a hash' do
      Updater.load_hubs!.should be_a Hash
    end

    it 'should include :com in the keys' do
      Updater.load_hubs!.should have_key(:com)
    end

    it 'should include the Portuguese hub in the values' do
      Updater.load_hubs!.should have_value('http://www.travian.pt/')
    end
  end

  describe 'hub_data!' do
    it 'scrapes hub data from travian.com' do
      Updater.send(:hub_data!).should_not be_nil
    end

    it 'should include the flags nested hash' do
      Updater.send(:hub_data!).should have_key(:flags)
    end
  end

  describe '.js_hash_to_ruby_hash' do
    it 'returns a hash when passed valed javascript hash code' do
      Updater.send(:js_hash_to_ruby_hash,
        "{'europe':'Europe','america':'America','asia':'Asia','middleEast':'Middle East','africa':'Africa','oceania':'Oceania'}"
      ).should be_a Hash
    end
  end
end
