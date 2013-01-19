Given /^I have no servers$/ do
  step "I should have 0 servers"
end

Given /^I have the hub (\w{2,6}) in the database with (\d+) servers$/ do |hub, n|
  pt_hub = FactoryGirl.create(:hub)
  n.to_i.times do |i|
    i += 1
    s = FactoryGirl.build(:server, name: "Servidor #{i}", code: "ts#{i}", host: "http://ts#{i}.travian.pt/", world_id: "pt#{i}#{i}")
    pt_hub.servers << s
  end
end

Given /^I have (\d+) servers in the database for the (\w{2,6}) hub$/ do |n, hub|
  pt_hub = FactoryGirl.create(:hub)
  [1, 2, 3, 4, 5, 6, 7, 8, 10].each do |i|
    s = FactoryGirl.build(:server, name: "Servidor#{i}", code: "ts#{i}", host: "http://ts#{i}.travian.pt/", world_id: "pt#{i}#{i}")
    s.hubs << pt_hub
    s.save
  end
  tx3 = FactoryGirl.build(:server, name: "Speed3x", code: "tx3", host: "http://tx3.travian.pt/", world_id: "ptx18")
  tx3.hubs << pt_hub
  tx3.save
end

Then /^I should have (\d+) servers?$/ do |n|
  Server.count.should == n.to_i
end

Then /^I should have (\d+) servers in the (\w{2,6}) hub$/ do |n, hub|
  Server.joins(:hubs).where("hubs.code = 'pt'").count.should == n.to_i
end

Then /^I should have loaded the servers$/ do
  Server.count.should > 200
end

Then /^I should have (\d+) servers in the (\w{2,6}) hub with an end date$/ do |n, hub|
  Server.joins(:hubs).where("hubs.code = 'pt' AND servers.end_date IS NOT NULL").count.should == n.to_i
end