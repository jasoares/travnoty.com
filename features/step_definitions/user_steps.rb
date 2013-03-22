Given /^my username is "(.*)"$/ do |username|
  @user.update_attributes(username: username)
end

Given /^(?:I am|I have|I) signed up (?:as|with) "(.*)"$/ do |email|
  @password = 'mysecretpassword'
  @user = create(:user, email: email, password: @password)
end

Given /^(?:I am|I have|I'm) signed in$/ do
  visit sign_in_path
  step "I fill in \"Username or Email\" with \"#{@user.email}\""
  step "I fill in \"Password\" with \"#{@password}\""
  step "I press \"Sign in\""
end

Given /^(?:I am|I have|I'm) signed in with another account$/ do
  @another_password = 'myothersecretpassword'
  @another_user = create(:user, email: 'another@example.com', password: @another_password)
  visit sign_in_path
  step "I fill in \"Username or Email\" with \"#{@another_user.email}\""
  step "I fill in \"Password\" with \"#{@another_password}\""
  step "I press \"Sign in\""
end

Given /^I just reset my password successfully$/ do
  step "I follow the password reset link sent in the email"
  step "I fill in \"New Password\" with \"newpassword\""
  step "I fill in \"Password confirmation\" with \"newpassword\""
  step "I press \"Change password\""
  step "I should see \"Password has been reset\""
end

Given /^the token has expired$/ do
  Timecop.freeze(Time.now.utc + 1.hour + @user.class.token_valid_duration)
end

Given /^the email is already confirmed$/ do
  @confirmation_token = @user.confirmation_token
  @user.confirm!(@confirmation_token)
end

When /^I follow the password reset link sent in the email(?: again)?$/ do
  visit edit_password_path(id: @user.reset_password_token)
end

When /^I sign in$/ do
  step "I fill in \"Username or Email\" with \"#{@user.email}\""
  step "I fill in \"Password\" with \"#{@password}\""
  step "I press \"Sign in\""
end

When /^I follow the confirmation link sent in the email(?: again)?$/ do
  confirmation_token = @user.confirmation_token || @confirmation_token
  visit confirm_email_path(id: @user.id, confirmation_token: confirmation_token)
end

Then /^an email with reset instructions should be sent to "(.*)"$/ do |email|
  @user = User.find_by_email(email)
  @user.reset_password_token.should_not be_blank
end

Then /^an email with confirmation instructions should be sent to "(.*)"$/ do |email|
  @user = User.find_by_email(email)
  @user.confirmation_token.should_not be_blank
end

Then /^an email with the pre subscription confirmation should be sent to "(.*)"$/ do |email|
  PreSubscription.find_by_email(email).should_not be_nil
end
