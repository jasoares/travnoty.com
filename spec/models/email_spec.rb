require 'spec_helper'

describe Email do
  describe '#address' do
    it 'is required' do
      expect(build(:email, address: '').errors_on(:address)).to include("can't be blank")
    end

    it 'should require a domain and a tld' do
      expect(build(:email, address: 'johndoe@gmail').errors_on(:address)).to include("has an invalid format")
    end

    it 'should be of the format <user>@domain.tld' do
      expect(build(:email, address: 'johndoe.gmail.com').errors_on(:address)).to include("has an invalid format")
    end

    it 'should be unique' do
      create(:email_with_user, address: 'johndoe@gmail.com')
      expect(build(:email, address: 'johndoe@gmail.com').errors_on(:address)).to include('has already been taken')
    end
  end

  describe '#user' do
    it 'is required' do
      email = build(:email, user: nil)
      expect(email.errors_on(:user)).to include("can't be blank")
    end
  end

  describe '#confirmed?' do
    it 'returns true if the email was confirmed' do
      email = build(:email)
      email.confirmed_at = DateTime.now
      email.confirmed?.should be_true
    end

    it 'returns false if the email was not confirmed' do
      build(:email).confirmed?.should be_false
    end
  end

  describe '#generate_confirmation_token' do
    let(:email) { build(:email_with_user) }
    it 'generates a confirmation token to be sent in the confirmation email' do
      email.confirmation_token.should be_nil
      email.save!
      email.confirmation_token.should be_a String
    end

    it 'sets the confirmation_sent_at attribute to now' do
      email.confirmation_sent_at.should be_nil
      email.save!
      email.confirmation_sent_at.should be_an ActiveSupport::TimeWithZone
    end

    it 'makes sure every confirmation token is unique' do
      Email.stub_chain(:where, :first).and_return(true, true, false)
      SecureRandom.should_receive(:base64).exactly(3).times
      email.generate_confirmation_token
    end
  end

  describe '#confirm' do
    let(:email) { create(:email_with_user) }  

    it 'sets the confirmed_at attribute to now' do
      email.stub(:confirmation_period_expired? => false)
      email.confirmed_at.should be_nil
      email.confirm
      email.confirmed_at.should be_an ActiveSupport::TimeWithZone
      email.errors.should be_empty
    end

    it 'resets the confirmation token when successfully confirmed' do
      email.stub(:confirmation_period_expired? => false)
      email.confirm
      email.confirmation_token.should be_nil
    end

    it 'returns true when successfully confirmed' do
      email.stub(:confirmation_period_expired? => false)
      email.confirm.should be_true
    end

    it 'returns false when unsuccessfully confirmed' do
      email.stub(:confirmation_period_expired? => true)
      email.confirm.should be_false
    end

    it 'returns false and adds an error to the base object if the email is already confirmed' do
      email.stub(:confirmation_period_expired? => false)
      email.confirm
      email.confirm
      expect(email.errors[:base]).to include('Already confirmed.')
    end

    it 'returns false and adds an error to the base object if the period expired' do
      email.stub(:confirmation_period_expired? => true)
      email.confirm
      email.confirmed_at.should be_nil
      expect(email.errors[:base]).to include('Confirmation period expired.')
    end
  end

  describe '.confirmation_period_expired?' do
    it 'returns true if the confirmation period expired' do
      Timecop.freeze(2.days.ago)
      email = create(:email_with_user)
      Timecop.return
      email.confirmation_period_expired?.should be_true
    end

    it 'returns false if the confirmation period has not expired' do
      Timecop.freeze(2.hours.ago)
      email = create(:email_with_user)
      Timecop.return
      email.confirmation_period_expired?.should be_false
    end
  end

  describe '.send_confirmation_instructions' do
    let(:email) { create(:email_with_user) }

    it 'sends an email in an after create filter' do
      ActionMailer::Base.deliveries.should_not be_empty
    end

    it 'sends the email with the confirmation instructions' do
      mail = email.send :send_confirmation_instructions
      ActionMailer::Base.deliveries.last.should == mail
    end
  end
end
