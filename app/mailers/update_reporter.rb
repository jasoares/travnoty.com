class UpdateReporter < ActionMailer::Base
  default from: "jsoaresgeral@gmail.com"

  ADMIN = 'jsoaresgeral@gmail.com'

  def changed_hub(hub)
    @hub = hub

    mail to: ADMIN, subject: "#{hub.name}'s hub was changed"
  end

  def changed_server(server)
    @server = server

    mail to: ADMIN, subject: "#{server.host} was changed"
  end
end
