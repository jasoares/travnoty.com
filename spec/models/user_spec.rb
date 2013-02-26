require 'spec_helper'

describe User do
  it 'should be valid' do
    build(:user).should be_valid
  end

  describe '#email' do
    it 'is required' do
      expect(build(:user, email: '').errors_on(:email)).to include("can't be blank")
    end

    it 'should require a domain and a tld' do
      expect(build(:user, email: 'johndoe@gmail').errors_on(:email)).to include("is invalid")
    end

    it 'should be of the format <user>@domain.tld' do
      expect(build(:user, email: 'johndoe.gmail.com').errors_on(:email)).to include("is invalid")
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
end
