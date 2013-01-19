class UpdateReporter < ActionMailer::Base
  default from: "jsoaresgeral@gmail.com"

  ADMIN = 'jsoaresgeral@gmail.com'

  def server_status(server, action=:started)
    @server = server
    @subject = "Server #{server.host} has #{action.to_s}"
    mail to: ADMIN, subject: @subject
  end

  def update_error(hub, msg)
    @hub = hub
    @subject = "Error updating #{@hub.name}'s hub"
    @msg = msg
    mail to: ADMIN, subject: @subject
  end

end
