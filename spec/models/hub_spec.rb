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

  describe '.update!' do
    context 'when the table has no hubs' do
      it 'adds hubs to the table' do
        expect { Hub.update! }.to change { Hub.count }.from(0).to(55)
      end
    end

    context 'when provided with invalid hub data' do
      before(:each) do
        Hub.stub(:hub_data) { { pt: 'http://www.travian.pt' } } # no forward slash at the end
      end

      it 'should log an error message with "Error updating Portugal hub."' do
        Rails.logger.should_receive(:error).once.with('Error adding Portugal hub.')
        Hub.update!
      end
    end

    context 'when there are 2 hubs already in the table' do
      before(:each) do
        Hub.stub(:hub_data) { { pt: 'http://www.travian.pt/', it: 'http://www.travian.it/' } }
        Hub.update!
      end

      it 'should have 2 records' do
        Hub.all.should have(2).records
      end

      context 'when provided with the same hub data' do
        before(:each) do
          Hub.update!
        end

        it 'should not change anything' do
          expect { Hub.update! }.to_not change { Hub.all }
        end

        it 'should not log any message' do
          Rails.logger.should_not_receive(:info)
          Rails.logger.should_not_receive(:error)
        end
      end

      context 'when provided with invalid hub data' do
        before(:each) do
          Hub.stub(:hub_data) { { pt: 'http://www.travian.pt' } } # no forward slash at the end
        end

        it 'should log an error message with "Error updating Portugal hub."' do
          Rails.logger.should_receive(:error).once.with('Error updating Portugal hub.')
          Hub.update!
        end
      end

      context 'when provided with a new hub { com: "http://www.travian.com/" }' do
        before(:each) do
          Hub.stub(:hub_data) { { com: 'http://www.travian.com/' } }
        end

        it 'should add the new hub' do
          expect { Hub.update! }.to change { Hub.count }.from(2).to(3)
        end

        it 'should log an info message with "Internation hub added"' do
          Rails.logger.should_receive(:info).once.with('International hub added.')
          Hub.update!
        end

        it 'should not log an error message' do
          Rails.logger.should_not_receive(:error)
          Hub.update!
        end
      end

      context 'when provided with an updated hub { pt: "http://www.travian.com.pt/" }' do
        before(:each) do
          Hub.stub(:hub_data) { { pt: 'http://www.travian.com.pt/' } }
        end

        it 'should update the existent hub' do
          expect { Hub.update! }.to change { Hub.find_by_code('pt').host }.from('http://www.travian.pt/').to('http://www.travian.com.pt/')
        end

        it 'should log an info message with "Portugal hub added"' do
          Rails.logger.should_receive(:info).once.with('Portugal hub updated.')
          Hub.update!
        end

        it 'should not log an error message' do
          Rails.logger.should_not_receive(:error)
          Hub.update!
        end
      end
    end
  end

  describe '.hub_data' do
    it 'returns a hash' do
      Hub.send(:hub_data).should be_a Hash
    end

    it 'should include :com in the keys' do
      Hub.send(:hub_data).should have_key(:com)
    end

    it 'should include the Portuguese hub in the values' do
      Hub.send(:hub_data).should have_value('http://www.travian.pt/')
    end
  end

  describe '.data' do
    it 'scrapes hub data from travian.com' do
      Hub.send(:data).should_not be_nil
    end

    it 'should include the flags nested hash' do
      Hub.send(:data).should have_key(:flags)
    end
  end

  describe '.js_hash_to_ruby_hash' do
    it 'returns a hash when passed valed javascript hash code' do
      Hub.send(:js_hash_to_ruby_hash,
        "{'europe':'Europe','america':'America','asia':'Asia','middleEast':'Middle East','africa':'Africa','oceania':'Oceania'}"
      ).should be_a Hash
    end
  end
end
