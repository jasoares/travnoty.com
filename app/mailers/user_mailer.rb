class UserMailer < ActionMailer::Base
  default from: "welcome@travnoty.com"

  def email_confirmation(user)
    @user = user

    mail to: user.email, subject: "Welcome to Travnoty!"
  end

  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => "Password Reset"
  end

  def send_pre_subscription_confirmation(pre_subscription)
    @pre_subscription = pre_subscription

    mail to: pre_subscription.email, subject: "Thank you for showing you care", from: "contact@travnoty.com"
  end

end
