Given /^I (?:go to|am on) (?:the )?["']([^"']+)["'](?: page)?$/ do |page|
  visit path_to(page)
end

Given /^I fill in ["']([^"']+)["'] with ["']([^"']+)["']$/ do |field, value|
  fill_in(field, :with => value)
end

When /^I press ["']([^"']+)["']$/ do |button|
  click_button(button)
end

When /^I click on ["']([^"']+)["']$/ do |link|
  click_link(link)
end

Then /^I should see ["']([^"']+)["']$/ do |text|
  page.should have_content(text)
end
