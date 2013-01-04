require 'spec_helper'

describe ApplicationHelper do
  describe 'strip_host' do
    it 'returns "www.travian.com" when passed "http://www.travian.com/"' do
      strip_host("http://www.travian.com/").should == "www.travian.com"
    end

    it 'returns "www.travian.com" when passed "http://www.travian.com"' do
      strip_host("http://www.travian.com").should == "www.travian.com"
    end

    it 'returns "www.travian.com" when passed "www.travian.com"' do
      strip_host("www.travian.com").should == "www.travian.com"
    end
  end
end
