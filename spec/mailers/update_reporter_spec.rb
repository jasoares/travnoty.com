require "spec_helper"

describe UpdateReporter do
  describe '#start_round_notice' do
    let(:server) { mock_model(Server, host: 'ts1.travian.com', url: 'http://ts1.travian.com') }
    let(:round) { mock_model(Round, start_date: DateTime.now, version: "4.0", server: server) }
    let(:mail) { UpdateReporter.start_round_notice(round) }

    it 'renders the subject' do
      mail.subject.should == "#{server.host} is starting a new round on #{I18n.l round.start_date}"
    end

    it 'renders the receiver email' do
      mail.header['to'].value.should == UpdateReporter::ADMIN
    end

    it 'renders the sender email' do
      mail.header['from'].value.should == 'Travnoty Administrator <admin@travnoty.com>'
    end

    it 'assigns @round' do
      mail.body.encoded.should include(I18n.l round.start_date)
    end

    it 'assigns @server' do
      mail.body.encoded.should include(server.host)
    end
  end

  describe '#end_round_notice' do
    let(:server) { mock_model(Server, host: 'ts1.travian.com', url: 'http://ts1.travian.com') }
    let(:round) { mock_model(Round, start_date: DateTime.now - 340, version: "4.0", end_date: DateTime.now, server: server ) }
    let(:mail) { UpdateReporter.end_round_notice(round) }

    it 'renders the subject' do
      mail.subject.should == "#{server.host}'s round just ended today"
    end

    it 'renders the receiver email' do
      mail.header['to'].value.should == UpdateReporter::ADMIN
    end

    it 'renders the sender email' do
      mail.header['from'].value.should == UpdateReporter::ADMIN
    end

    it 'assigns @round' do
      mail.body.encoded.should include(I18n.l round.start_date)
    end

    it 'assigns @server' do
      mail.body.encoded.should include(server.host)
    end
  end

  describe 'on all mails' do
    let(:server) { mock_model(Server, host: 'ts1.travian.com', url: 'http://ts1.travian.com') }
    let(:round) { mock_model(Round, start_date: DateTime.now, version: "4.0", server: server) }
    let(:mail) { UpdateReporter.start_round_notice(round) }

    it "adds default category 'Admin' to X-SMTPAPI header for sendgrid" do
      header = { category: ["Admin"] }.to_json
      mail.header['X-SMTPAPI'].value.should == header
    end
  end
end
