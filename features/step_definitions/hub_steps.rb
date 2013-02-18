require 'travian_loader'
require 'travian_proxy'

Given /^I have no hubs$/ do
  step "I should have 0 hubs"
end

Given /^the following hubs exist$/ do |table|
  data = table.hashes.inject({}) do |new_hash, hub|
    hub['main_hub'] = nil if hub['main_hub'] == ""
    new_hash[hub['code']] = hub
    new_hash
  end
  TravianProxy.data = data.with_indifferent_access
end

Then /^I should have (?:loaded )?(\d+) hubs?$/ do |n|
  Hub.count.should == n.to_i
end

Then /^I should have (\d+) mirrors?$/ do |n|
  Hub.mirrors.size.should == n.to_i
end

Then /^I should have (\d+) main hubs?$/ do |n|
  Hub.main_hubs.size.should == n.to_i
end
