Given /^my username is "(.*)"$/ do |username|
  @user.update_attributes(username: username)
end

Given /^(?:I am|I have|I) signed up (?:as|with) "(.*)"$/ do |email|
  @user = build(:user, password: 'mysecretpassword')
  @user.emails << build(:email, address: email, user: @user, main_address: true)
  @user.save
end

When /^I follow the password reset link sent in the email$/ do
  visit edit_password_reset_path(id: @user.reset_password_token)
end

Then /^an email with reset instructions should be sent to "(.*)"$/ do |email|
  @user = Email.where(address: email).first.user
  @user.reset_password_token.should_not be_blank
end
