require 'spec_helper'

describe TravianAccount do
  it 'should be valid' do
    build(:travian_account, :with_user_and_round).should be_valid
  end

  describe '#username' do
    it 'is required' do
      build(:travian_account, username: '').should have_at_least(1).error_on(:username)
    end

    it 'is unique per server round' do
      account = create(:travian_account, :with_user_and_round)
      other_account = build(:travian_account, username: account.username, round: account.round)
      other_account.should have_at_least(1).error_on(:username)
    end
  end

  describe '#uid' do
    it 'is required' do
      build(:travian_account, uid: nil).should have_at_least(1).error_on(:uid)
    end

    it 'must be a number' do
      build(:travian_account, uid: 'abc').should have_at_least(1).error_on(:uid)
    end

    it 'must be an integer' do
      build(:travian_account, uid: 1.3).should have_at_least(1).error_on(:uid)
    end

    it 'must be greater than 2' do
      build(:travian_account, uid: 2).should have_at_least(1).error_on(:uid)
    end
  end

  describe '#user' do
    it 'is required' do
      build(:travian_account, user: nil).should have_at_least(1).error_on(:user)
    end
  end

  describe '#round' do
    it 'is required' do
      build(:travian_account, round: nil).should have_at_least(1).error_on(:round)
    end
  end
end
