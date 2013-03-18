require "spec_helper"

describe UserMailer do
  describe "email_confirmation" do
    let(:user) { create(:user) }
    let(:mail) { UserMailer.email_confirmation(user) }

    it "renders the headers" do
      mail.subject.should eq("Welcome to Travnoty!")
      mail.header['to'].value.should eq "#{user.name} <#{user.email}>"
      mail.header['from'].value.should eq "Travnoty <welcome@travnoty.com>"
    end

    it "renders the body" do
      mail.body.encoded.should match /confirm your account email/
    end
  end

  describe "password_reset" do
    let(:user) { create(:user) }
    let(:mail) { user.send_reset_password_instructions }

    it "renders the headers" do
      mail.subject.should eq "Password Reset"
      mail.header['to'].value.should eq "#{user.name} <#{user.email}>"
      mail.header['from'].value.should eq "Travnoty <noreply@travnoty.com>"
    end

    it "renders the body" do
      mail.body.encoded.should match /To reset your password, click the URL below./
    end
  end

  describe 'send_pre_subscription_confirmation' do
    let(:pre_subscription) { create(:pre_subscription) }
    let(:mail) { UserMailer.send_pre_subscription_confirmation(pre_subscription) }

    it 'renders the headers' do
      mail.subject.should eq "Thank you for your interest in Travnoty"
      mail.header['to'].value.should eq "#{pre_subscription.name} <#{pre_subscription.email}>"
      mail.header['from'].value.should eq "Travnoty <contact@travnoty.com>"
    end

    it "renders the body" do
      mail.body.encoded.should match /Thank you for your interest in Travnoty./
    end
  end

end
