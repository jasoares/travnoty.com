Given /^I fill in ["']([^"']+)["'] with ["']([^"']+)["']$/ do |field, value|
  fill_in(field, :with => value)
end

When /^I (?:go to|am on) (?:the )?(.+) page$/ do |page|
  visit path_to(page)
end

When /^I press ["']([^"']+)["']$/ do |button|
  click_button(button)
end

When /^I click on ["']([^"']+)["']$/ do |link|
  click_link(link)
end

Then /^I should be signed in$/ do
  step "I should see \"Sign out\""
end

Then /^I should be on the (.+) page$/ do |page_name|
  current_path = URI.parse(current_url).path
  current_path.should == path_to(page_name)
end

Then /^I should see "([^"]+)"$/ do |text|
  page.should have_content(text)
end

Then /^I should see an error message$/ do
  page.should have_selector('.error.form')
end
