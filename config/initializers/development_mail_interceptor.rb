class DevelopmentMailInterceptor

  def self.delivering_email(message)
    header = ActiveSupport::JSON.decode(message.header['X-SMTPAPI'].value).symbolize_keys
    header[:category] += ['Test']
    message.header['X-SMTPAPI'] = nil
    message.header['X-SMTPAPI'] = header.to_json
    message.to = ["dev@travnoty.com"]
  end

end

ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?
