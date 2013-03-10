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
end
