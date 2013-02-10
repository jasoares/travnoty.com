require 'spec_helper'

describe RoundObserver do
  let(:round) { stub_model(Round) }
  let(:observer) { RoundObserver.instance }

  describe '#after_create' do
    it 'calls the UpdateReporter.start_round_notice mailer with the round created' do
      email = double('Email', :deliver => true)
      UpdateReporter.should_receive(:start_round_notice).with(round).and_return(email)
      observer.after_create(round)
    end
  end

  describe '#after_update' do
    it 'calls sends an email when round\'s end_date changed from nil to a DateTime' do
      email = double('Email', :deliver => true)
      round.end_date = DateTime.now
      UpdateReporter.should_receive(:end_round_notice).with(round).and_return(email)
      observer.after_update(round)
    end

    it 'does nothing when round\'s end_date didn\'t change accordingly' do
      email = double('Email', :deliver => true)
      round.end_date = nil
      UpdateReporter.should_not_receive(:end_round_notice)
      observer.after_update(round)
    end
  end
end
