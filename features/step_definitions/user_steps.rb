Given /^my username is "(.*)"$/ do |username|
  @user.update_attributes(username: username)
end

Given /^(?:I am|I have|I) signed up (?:as|with) "(.*)"$/ do |email|
  @user = create(:user, email: email, password: 'mysecretpassword')
end

Given /^I just reset my password successfully$/ do
  step "I follow the password reset link sent in the email"
  step "I fill in \"New Password\" with \"newpassword\""
  step "I fill in \"Password confirmation\" with \"newpassword\""
  step "I press \"Change password\""
  step "I should see \"Password has been reset!\""
end

When /^I follow the password reset link sent in the email(?: again)?$/ do
  visit edit_password_reset_path(id: @user.reset_password_token)
end

Then /^an email with reset instructions should be sent to "(.*)"$/ do |email|
  @user = User.find_by_email(email)
  @user.reset_password_token.should_not be_blank
end
