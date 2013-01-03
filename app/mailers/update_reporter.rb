class UpdateReporter < ActionMailer::Base
  default from: "jsoaresgeral@gmail.com"

  ADMIN = 'jsoaresgeral@gmail.com'

  def server_status(server, action=:started)
    @server = server
    @subject = "Server #{server.host} has #{action.to_s}"
    mail to: ADMIN, subject: @subject
  end

end
