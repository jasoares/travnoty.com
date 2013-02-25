require 'spec_helper'

describe Admin do
  it 'should be valid' do
    build(:admin).should be_valid
  end

  describe '#email' do
    it 'is required' do
      expect(build(:admin, email: '').errors_on(:email)).to include("can't be blank")
    end

    it 'should require a domain and a tld' do
      expect(build(:admin, email: 'admin@gmail').errors_on(:email)).to include("is invalid")
    end

    it 'should be of the format <admin>@domain.tld' do
      expect(build(:admin, email: 'admin.gmail.com').errors_on(:email)).to include("is invalid")
    end
  end

  describe '#password' do
    it "can't be blank" do
      expect(build(:admin, password: '').errors_on(:password)).to include("can't be blank")
    end

    it "can't be nil" do
      expect(build(:admin, password: nil).errors_on(:password)).to include("can't be blank")
    end

    it 'must match confirmation' do
      expect(build(:admin, password_confirmation: 'other').errors_on(:password)).to include("doesn't match confirmation")
    end

    it 'must have a length of at least 8' do
      expect(build(:admin, password: '1234567', password_confirmation: '1234567').errors_on(:password)).to include("is too short (minimum is 8 characters)")
    end
  end

  describe '#password_confirmation' do
    context 'when creating a new record' do
      it "can't be nil" do
        expect(build(:admin, password_confirmation: nil).errors_on(:password_confirmation)).to include("can't be blank")
      end
    end
  end
end
