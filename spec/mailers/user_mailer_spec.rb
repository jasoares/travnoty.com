require "spec_helper"

describe UserMailer do
  describe "email_confirmation" do
    let(:user) { create(:user) }
    let(:mail) { UserMailer.email_confirmation(user) }

    it "renders the headers" do
      mail.subject.should eq("Welcome to Travnoty!")
      mail.to.should eq([user.email])
      mail.from.should eq(["welcome@travnoty.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match /confirm your account email/
    end

    describe 'send_pre_subscription_confirmation' do
      let(:pre_subscription) { create(:pre_subscription) }
      let(:mail) { UserMailer.send_pre_subscription_confirmation(pre_subscription) }

      it 'renders the headers' do
        mail.subject.should eq("Thank you for your interest in Travnoty")
        mail.to.should eq([pre_subscription.email])
        mail.from.should eq(["contact@travnoty.com"])
      end

      it "renders the body" do
        mail.body.encoded.should match /Thank you for your interest in Travnoty./
      end
    end
  end

end
