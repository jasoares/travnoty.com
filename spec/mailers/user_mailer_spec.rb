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
  end

end
