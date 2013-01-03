require "spec_helper"

describe UpdateReporter do
  describe '.server_status' do
    context 'when passed a server and the :started symbol' do
      let(:server) { FactoryGirl.create(:server) }
      let(:mail)   { UpdateReporter.server_status(server, :started) }

      it 'renders the subject' do
        mail.subject.should == "Server #{server.host} has started"
      end

      it 'sets the email destion to UpdateReporter::ADMIN' do
        mail.to.should == [UpdateReporter::ADMIN]
      end

      it 'sets the sender email to UpdateReporter::ADMIN' do
        mail.from.should == [UpdateReporter::ADMIN]
      end

      it 'assigns @name' do
        mail.body.encoded.should match(server.host)
      end
    end
  end
end
