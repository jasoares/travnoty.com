Given /^I have no servers$/ do
  step "I should have 0 servers"
end

Then /^I should have (\d+) servers?$/ do |n|
  Server.count.should == n.to_i
end

Then /^I should have loaded the servers$/ do
  Server.count.should > 200
end
