Given /^I go to (?:the )?["']([^"']+)["'](?: page)?$/ do |page|
  visit path_to(page)
end

Given /^I fill in ["']([^"']+)["'] with ["']([^"']+)["']$/ do |field, value|
  fill_in(field, :with => value)
end

When /^I press ["']([^"']+)["']$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should see ["']([^"']+)["']$/ do
  pending # express the regexp above with the code you wish you had
end
