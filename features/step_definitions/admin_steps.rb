Given /^there are no admins$/ do
  step "I should have 0 admins"
end

Given /^an admin was created with ["']([\w\.@]+)["'] and ["'](\w+)["']$/ do |email, pass|
  create(:admin, email: email, password: pass)
end

Given /^I have set the ENV\['(\w+)'\] to ['"]([\w@\.]+)[#']$/ do |var, value|
  ENV[var] = value
end

Given /^I am signed in$/ do
  step "I fill in 'admin_email' with 'admin@travnoty.com'"
  step "I fill in 'admin_password' with 'adminpassword'"
  step "I press 'Sign in'"
end

Then /^I should have (\d+) admins?$/ do |n|
  Admin.count.should == n.to_i
end

Then /^its (\w+) should be "(.*?)"$/ do |attribute, value|
  Admin.first.send(attribute).should == value
end
