require 'spec_helper'

describe User do
  it 'should be valid' do
    build(:user).should be_valid
  end

  describe '#username' do
    it 'is required' do
      expect(build(:user, username: '').errors_on(:username)).to include('can\'t be blank')
    end

    it 'should be unique' do
      create(:user, username: 'johndoe')
      expect(build(:user, username: 'johndoe').errors_on(:username)).to include("has already been taken")
    end

    it 'should accept multiple blank usernames' do
      create(:user)
      expect(build(:user).errors_on(:username)).not_to include("has already been taken")
    end

    it 'should preserve letter case when persisted' do
      create(:user, username: 'JohnDoe')
      User.find_by_username('JohnDoe').username.should == 'JohnDoe'
    end

    it 'should not have spaces' do
      expect(build(:user, username: 'John Doe').errors_on(:username).first).to match /may only contain/
    end

    it 'should not start with a dash' do
      expect(build(:user, username: '-johndoe').errors_on(:username).first).to match /may only contain/
    end

    it 'should not contain any characters other than dashes, letters or numbers' do
      expect(build(:user, username: 'john_doe').errors_on(:username).first).to match /may only contain/
    end

    it 'allows dashes when not starting with one' do
      expect(build(:user, username: 'john-doe543')).to be_valid
    end

    it 'accepts numbers at the start and beyond' do
      expect(build(:user, username: '12john3doe45')).to be_valid
    end
  end

  describe '#email' do
    it 'is required' do
      expect(build(:user, email: '').errors_on(:email)).to include("can't be blank")
    end

    it 'should require a domain and a tld' do
      expect(build(:user, email: 'johndoe@gmail').errors_on(:email)).to include("has an invalid format")
    end

    it 'should be of the format <user>@domain.tld' do
      expect(build(:user, email: 'johndoe.gmail.com').errors_on(:email)).to include("has an invalid format")
    end

    it 'should be unique' do
      create(:user, email: 'johndoe@gmail.com')
      expect(build(:user, email: 'johndoe@gmail.com').errors_on(:email)).to include('is already associated to an account')
    end

    it 'should be converted to lowercase when persisted' do
      create(:user, email: 'JohnDoe@gmail.com')
      User.find_by_normalized_email('JohnDoe@gmail.com').email.should == 'johndoe@gmail.com'
    end
  end

  describe '#password' do
    it "can't be blank" do
      expect(build(:user, password: '').errors_on(:password)).to include("can't be blank")
    end

    it "can't be nil" do
      expect(build(:user, password: nil).errors_on(:password)).to include("can't be blank")
    end

    it 'must match confirmation' do
      expect(build(:user, password_confirmation: 'other').errors_on(:password)).to include("doesn't match confirmation")
    end

    it 'must have a length of at least 8' do
      expect(build(:user, password: '1234567').errors_on(:password)).to include("is too short (minimum is 8 characters)")
    end
  end

  describe '#password_confirmation' do
    it 'should be required when creating a new record' do
      user = build(:user, password_confirmation: '')
      expect(user.errors_on(:password)).to include('doesn\'t match confirmation')
    end

    it 'should be required when updating/resetting password' do
      user = create(:user)
      user.password_confirmation = ''
      expect(user.errors_on(:password)).to include('doesn\'t match confirmation')
    end

    it 'should match the password field when it is present' do
      user = build(:user, password: '12345678', password_confirmation: '87654321')
      expect(user.errors_on(:password)).to include('doesn\'t match confirmation')
    end
  end

  describe '#generate_confirmation_token' do
    let(:user) { build(:user) }
    it 'generates a confirmation token to be sent in the confirmation email' do
      user.confirmation_token.should be_nil
      user.save!
      user.confirmation_token.should be_a String
    end

    it 'sets the confirmation_sent_at attribute to now' do
      user.confirmation_sent_at.should be_nil
      user.save!
      user.confirmation_sent_at.should be_an ActiveSupport::TimeWithZone
    end

    it 'makes sure every confirmation token is unique' do
      User.stub(:exists?).and_return(true, true, false)
      SecureRandom.should_receive(:urlsafe_base64).exactly(3).times
      user.generate_confirmation_token
    end
  end

  describe '#confirm' do
    let(:user) { create(:user) }  

    it 'sets the confirmed_at attribute to now' do
      user.confirmed_at.should be_nil
      user.confirm
      user.confirmed_at.should be_an ActiveSupport::TimeWithZone
    end

    it 'returns true when successfully confirmed' do
      user.confirm.should be_true
    end
  end

  describe 'confirmed?' do
    let(:user) { create(:user) }

    it 'returns true when confirmed_at has a value' do
      user.stub(confirmed_at: Time.now.utc)
      user.confirmed?.should be_true
    end

    it 'returns false when confirmed_at is nill' do
      user.stub(confirmed_at: nil)
      user.confirmed?.should be_false
    end
  end

  describe '#send_confirmation_instructions' do
    before { ActionMailer::Base.deliveries = [] }

    it 'sends an email in an after create filter' do
      expect { create(:user) }.to change {
        ActionMailer::Base.deliveries.empty?
      }.from(true).to(false)
    end

    it 'sends the email with the confirmation instructions' do
      mail = create(:user).send :send_confirmation_instructions
      ActionMailer::Base.deliveries.last.should == mail
    end
  end

  describe '#resend_confirmation_instructions' do
    let(:user) { create(:user) }

    it 'resends the confirmation email if the confirmation is pending' do
      user.stub(:confirmation_pending? => true)
      user.should_receive(:send_confirmation_instructions)
      user.send :resend_confirmation_instructions
    end

    it 'does not send the confirmation email if it is already confirmed' do
      user.stub(:confirmation_pending? => false)
      user.should_not_receive(:send_confirmation_instructions)
      user.send :resend_confirmation_instructions
    end
  end

  describe '#confirmed?' do
    it 'returns true if the email was confirmed' do
      build(:user, confirmed_at: DateTime.now).confirmed?.should be_true
    end

    it 'returns false if the email was not confirmed' do
      build(:user).confirmed?.should be_false
    end
  end

  describe '#encrypt_password' do
    let(:user) { build(:user) }

    it 'encrypts the password field into encrypted password before saving the record' do
      user.password_hash.should be_nil
      user.save
      user.password_hash.should be_a String
    end
  end

  describe '#reset_password' do
    before do
      @user = create(:user)
      @user.generate_reset_password_token!
    end

    it 'resets the reset_password_token to nil when passed a valid password' do
      @user.reset_password('mysecretpassword')
      @user.reset_password_token.should be_nil
    end

    it 'resets the reset_token_sent_at to nil when passed a valid password' do
      @user.reset_password('mysecretpassword')
      @user.reset_token_sent_at.should be_nil
    end

    it 'changes the encrypted_password to the new password passed' do
      expect {
        @user.reset_password('mysecretpassword')
      }.to change { @user.password_hash }
    end

    it 'returns true if the password is successfully changed' do
      @user.reset_password('mysecretpassword').should be_true
    end

    it 'returns false if the password change fails' do
      @user.reset_password('secret').should be_false #fails validation
    end
  end

  describe '#send_reset_password_instructions' do
    let(:user) { create(:user) }

    it 'generates the reset password token' do
      expect { user.send_reset_password_instructions }.to change { user.reset_password_token }.from(nil)
    end

    it 'saves the current date to reset_token_sent_at' do
      expect { user.send_reset_password_instructions }.to change { user.reset_token_sent_at }.from(nil)
    end

    it 'sends an email with the reset password instructions' do
      mail = double('Mail')
      mail.should_receive(:deliver)
      UserMailer.should_receive(:password_reset).with(user).and_return(mail)
      user.send_reset_password_instructions
    end
  end

  describe '.authenticate' do
    let(:user) { create(:user) }

    it 'returns a user object when successfully authenticated with email' do
      User.authenticate(user.email, user.password).should == user
    end

    it 'returns a user object when successfully authenticated with username' do
      User.authenticate(user.username, user.password).should == user
    end

    it 'returns nil when authentication fails' do
      User.authenticate(user.email, 'wrongpassword').should be_nil
    end

    it 'returns a user object when successfully authenticated with different case email' do
      User.authenticate(user.email.upcase, user.password).should == user
    end

    it 'returns a user object when successfully authenticated with different case username' do
      User.authenticate(user.username.upcase, user.password).should == user
    end
  end

  describe '.find_by_normalized_email' do
    it 'performs case insensitive queries for email' do
      user = create(:user)
      User.find_by_normalized_email(user.email.upcase).should == user
    end
  end

  describe '.find_by_username' do
    it 'performs case insensitive queries against persisted mixed case usernames' do
      user = create(:user, :username => 'JohnDoe')
      User.find_by_username('joHndoE').should == user
    end
  end

  describe '.normalize_email' do
    it 'removes extra whitespace' do
      User.normalize_email('  johndoe@example.com ').should == 'johndoe@example.com'
    end

    it 'converts to downcase' do
      User.normalize_email('JohnDoe@Example.Com').should == 'johndoe@example.com'
    end
  end

end
