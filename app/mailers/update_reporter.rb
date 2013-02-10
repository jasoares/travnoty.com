class UpdateReporter < ActionMailer::Base
  default from: "internal@travnoty.com"

  ADMIN = 'jsoaresgeral@gmail.com'

  def update_error(hub, msg)
    @hub = hub
    @subject = "Error updating #{@hub.name}'s hub"
    @msg = msg
    mail to: ADMIN, subject: @subject
  end

  def start_round_notice(round)
    @round = round
    @server = round.server
    @subject = "#{@round.server.host} is starting a new round on #{I18n.l round.start_date}"
    mail to: ADMIN, subject: @subject
  end

  def end_round_notice(round)
    @round = round
    @server = round.server
    @subject = "#{@round.server.host}'s round just ended today"
    mail to: ADMIN, subject: @subject
  end
end
