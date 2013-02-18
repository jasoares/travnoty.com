Given /^I have no servers$/ do
  step "I should have 0 servers"
end

Given /^I have a server with the following rounds$/ do |table|
  @server = FactoryGirl.create(:server)
  table.hashes.each do |row|
    start_date, end_date = row.values.map { |str| str == 'nil' ? nil : Date.strptime(str, "%d-%m-%Y") }
    round = FactoryGirl.build(:round, start_date: start_date, end_date: end_date)
    @server.rounds << round
  end
end

Given /^the following (?:new )?servers(?: exist| were announced)?$/ do |table|
  hash = TravianProxy.data
  table.hashes.each do |server|
    server['speed'] = server['speed'].to_i
    server['start_date'] = DateTime.strptime(server['start_date'], "%d-%m-%Y")
    hub = server.delete('hub')
    hash[hub][:servers] ||= {}
    hash[hub][:servers].merge!({ server['code'] => server })
  end
  TravianProxy.data = hash.with_indifferent_access
end

Given /^I have a server with no rounds$/ do
  @server = FactoryGirl.create(:server)
end

Given /^the following servers no longer exist$/ do |table|
  hash = TravianProxy.data
  table.hashes.each do |server|
    hub, code = server.values
    hash[hub][:servers][code][:start_date] = nil
  end
  TravianProxy.data = hash
end

Then /^it should rollback$/ do
  (@server.rounds << @round).should be false
end

Then /^I should (?:still )?have (?:loaded )?(\d+) servers?$/ do |n|
  Server.count.should == n.to_i
end

Then /^I should have (\d+) restarting servers?$/ do |n|
  Server.restarting.size.should == n.to_i
end
