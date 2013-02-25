Given /^there are no admins$/ do
  step "I should have 0 admins"
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
