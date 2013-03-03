require "spec_helper"

describe UserMailer do
  describe "email_confirmation" do
    let(:email) { create(:email_with_user) }
    let(:mail) { UserMailer.email_confirmation(email.user, email) }

    it "renders the headers" do
      mail.subject.should eq("Welcome to Travnoty!")
      mail.to.should eq([email.address])
      mail.from.should eq(["welcome@travnoty.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match /confirm your account email/
    end
  end

end
