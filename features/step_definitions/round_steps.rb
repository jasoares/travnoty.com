Given /^I have no rounds$/ do
  step "I should have 0 rounds"
end

Then /^I should have (\d+) rounds?$/ do |n|
  Round.count.should == n.to_i
end

Then /^I should have loaded the rounds$/ do
  Round.count.should > 200
end
