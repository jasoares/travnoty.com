require 'spec_helper'

describe PreSubscription do
  it 'should be valid' do
    build(:pre_subscription).should be_valid
  end

  describe '#name' do
    it 'is required' do
      expect(build(:pre_subscription, name: '').errors_on(:name)).to include('can\'t be blank')
    end
  end

  describe '#hub' do
    it 'is not required' do
      expect(build(:pre_subscription, hub: nil)).to be_valid
    end
  end

  describe '#email' do
    it 'is required' do
      expect(build(:pre_subscription, email: '').errors_on(:email)).to include("can't be blank")
    end

    it 'should require a domain and a tld' do
      expect(build(:pre_subscription, email: 'johndoe@gmail').errors_on(:email)).to include("has an invalid format")
    end

    it 'should be of the format <user>@domain.tld' do
      expect(build(:pre_subscription, email: 'johndoe.gmail.com').errors_on(:email)).to include("has an invalid format")
    end

    it 'should be unique' do
      create(:pre_subscription, email: 'johndoe@gmail.com')
      expect(build(:pre_subscription, email: 'johndoe@gmail.com').errors_on(:email)).to include('is already subscribed')
    end

    it 'should be converted to lowercase when persisted' do
      create(:pre_subscription, email: 'JohnDoe@gmail.com')
      PreSubscription.find_by_normalized_email('JohnDoe@gmail.com').email.should == 'johndoe@gmail.com'
    end
  end

  describe '#send_pre_subscription_confirmation' do
    let(:pre_subscription) { build(:pre_subscription) }

    it 'sends an email to the pre subscriber' do
      mail = double('Mail')
      mail.should_receive(:deliver)
      UserMailer.should_receive(:pre_subscription_confirmation).with(pre_subscription).and_return(mail)
      pre_subscription.send_pre_subscription_confirmation
    end
  end
end
