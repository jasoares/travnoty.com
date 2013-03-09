require 'spec_helper'

describe User do
  it 'should be valid' do
    build(:user_with_email).should be_valid
  end

  describe '#username' do
    it 'should be unique' do
      create(:user_with_email, username: 'johndoe')
      expect(build(:user, username: 'johndoe').errors_on(:username)).to include("has already been taken")
    end

    it 'should accept multiple blank usernames' do
      create(:user_with_email)
      expect(build(:user).errors_on(:username)).not_to include("has already been taken")
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
      user = create(:user_with_email)
      user.password_confirmation = ''
      expect(user.errors_on(:password)).to include('doesn\'t match confirmation')
    end

    it 'should match the password field when it is present' do
      user = build(:user, password: '12345678', password_confirmation: '87654321')
      expect(user.errors_on(:password)).to include('doesn\'t match confirmation')
    end
  end

  describe '#emails' do
    it 'requires at least one email' do
      user = build(:user, emails: [])
      expect(user.errors_on(:emails)).to include('can\'t be blank')
    end
  end

  describe '#encrypt_password' do
    let(:user) { build(:user_with_email) }

    it 'encrypts the password field into encrypted password before saving the record' do
      user.password_hash.should be_nil
      user.save
      user.password_hash.should be_a String
    end
  end

  describe '#change_password' do
    before(:each) do
      @user = create(:user_with_email)
      @user.send_password_reset
    end

    it 'resets the reset_password_token to nil when passed a valid password' do
      @user.change_password(password: 'mysecretpassword')
      @user.reset_password_token.should be_nil
    end

    it 'resets the reset_token_sent_at to nil when passed a valid password' do
      @user.change_password(password: 'mysecretpassword')
      @user.reset_token_sent_at.should be_nil
    end

    it 'changes the encrypted_password to the new password passed' do
      expect {
        @user.change_password(password: 'mysecretpassword')
      }.to change { @user.password_hash }
    end

    it 'returns true if the password is successfully changed' do
      @user.change_password(password: 'mysecretpassword').should be_true
    end

    it 'returns false if the password change fails' do
      @user.change_password(password: 'secret').should be_false #fails validation
    end
  end

  describe '#send_password_reset' do
    let(:user) { create(:user_with_email) }

    it 'generates the reset password token' do
      expect { user.send_password_reset }.to change { user.reset_password_token }.from(nil)
    end

    it 'saves the current date to reset_token_sent_at' do
      expect { user.send_password_reset }.to change { user.reset_token_sent_at }.from(nil)
    end

    it 'sends an email with the reset password instructions' do
      mail = double('Mail')
      mail.should_receive(:deliver)
      UserMailer.should_receive(:password_reset).with(user).and_return(mail)
      user.send_password_reset
    end
  end

end
