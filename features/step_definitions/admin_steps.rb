Given /^there are no admins$/ do
  step "I should have 0 admins"
end

Given /^an admin was created with ["']([\w\.@]+)["'] and ["'](\w+)["']$/ do |email, pass|
  step "I have set the ENV['USER_EMAIL'] to '#{email}'"
  step "I have set the ENV['USER_PASSWORD'] to '#{pass}'"
end

Given /^I have set the ENV\['(\w+)'\] to ['"]([\w@\.]+)[#']$/ do |var, value|
  ENV[var] = value
end

Then /^I should have (\d+) admins?$/ do |n|
  Admin.count.should == n.to_i
end

Then /^its (\w+) should be "(.*?)"$/ do |attribute, value|
  Admin.first.send(attribute).should == value
end
