Given /^I have no hubs$/ do
  step "I should have 0 hubs"
end

Then /^I should have (\d+) hubs?$/ do |n|
  Hub.count.should == n.to_i
end