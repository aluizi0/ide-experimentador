When /^I visit hello page$/ do
  visit '/hello/world'
end
Then('I should see {string}') do |string|
  assert_selector "h1", text: string
end
  