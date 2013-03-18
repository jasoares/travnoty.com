class UserMailer < ActionMailer::Base
  default from: "Travnoty <welcome@travnoty.com>"
  default "X-SMTPAPI" => { category: ["User"] }.to_json

  def email_confirmation(user)
    @user = user

    mail  to: "#{user.name} <#{user.email}>",
          subject: "Welcome to Travnoty!"
  end

  def password_reset(user)
    @user = user
    mail  to: "#{user.name} <#{user.email}>",
          subject: "Password Reset",
          from: "Travnoty <noreply@travnoty.com>"
  end

  def pre_subscription_confirmation(pre_subscription)
    @pre_subscription = pre_subscription

    mail  to: "#{pre_subscription.name} <#{pre_subscription.email}>",
          from: "Travnoty <contact@travnoty.com>",
          subject: "Thank you for your interest in Travnoty"
  end

end
