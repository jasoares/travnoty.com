Given /^I have no hubs$/ do
  step "I should have 0 hubs"
end

Then /^I should have (\d+) hubs?$/ do |n|
  Hub.count.should == n.to_i
end

Then /^I should have loaded the hubs?$/ do
  Hub.count.should > 40
end
