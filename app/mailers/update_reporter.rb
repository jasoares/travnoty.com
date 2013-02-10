class UpdateReporter < ActionMailer::Base
  default from: "internal@travnoty.com"

  ADMIN = 'jsoaresgeral@gmail.com'

  def update_error(hub, msg)
    @hub = hub
    @subject = "Error updating #{@hub.name}'s hub"
    @msg = msg
    mail to: ADMIN, subject: @subject
  end

end
