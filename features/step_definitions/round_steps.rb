Given /^I have no rounds$/ do
  step "I should have 0 rounds"
end

When /^the update process tries to add the following round$/ do |table|
  values = table.hashes.first.values
  start_date, end_date = values.map { |str| str == 'nil' ? nil : Date.strptime(str, "%d-%m-%Y") }
  @round = FactoryGirl.build(:round, start_date: start_date, end_date: end_date)
  @server.rounds << @round
end

When /^the update process tries to add a new round$/ do
  @round = FactoryGirl.build(:running_round)
  @server.rounds << @round
end

When /^the update process tries to add a restarting round$/ do
  @round = FactoryGirl.build(:restarting_round)
  @server.rounds << @round
end

Then /^I should end up with (\d+) rounds?$/ do |n|
  @server.rounds << @round if @round and @round.new_record?
  Server.find(@server).rounds.size.should be n.to_i
end

Then /^I should have (?:loaded )?(\d+) rounds?$/ do |n|
  Round.count.should == n.to_i
end

Then /^I should have loaded the rounds$/ do
  Round.count.should > 200
end
