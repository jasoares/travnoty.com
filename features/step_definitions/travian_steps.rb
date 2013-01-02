Given /^there are now (\d+) (\w{2,6}) servers online$/ do |n, hub|
  Travian.hubs[:"#{hub}"].servers.size.should == n.to_i
end
