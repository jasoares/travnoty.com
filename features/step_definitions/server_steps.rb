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

Given /^I have a server with no rounds$/ do
  @server = FactoryGirl.create(:server)
end

Then /^it should rollback$/ do
  (@server.rounds << @round).should be false
end

Then /^I should have (\d+) servers?$/ do |n|
  Server.count.should == n.to_i
end

Then /^I should have loaded the servers$/ do
  Server.count.should > 200
end
