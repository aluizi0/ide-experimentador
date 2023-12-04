Before do
  Experiment.create(name: 'Experimento 1')
  Tag.create(name: 'Tag 1', color: 'red')
  Tag.create(name: 'Tag 2', color: 'blue')
end

Given("I am on the {string} page") do |string|
  visit string
end

When("I select tag with id {string}") do |string|
  # click the select
  find(:css, '#select-1').click
  # click the option
  find(:css, '#' + string).click
end

Then("I should see the tag {string}") do |string|
  expect(page).to have_content(string)
end
