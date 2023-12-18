Before do
  Experiment.create(name: 'Experimento 1')
  Tag.create(name: 'Tag 1', color: 'red')
  Tag.create(name: 'Tag 2', color: 'blue')
end

Given("I am on the {string} page") do |string|
  visit string
end

When("I click on the tag with id {string}") do |string|
  find(:css, '#' + string).click
end

And("I click on the add button with id {string}") do |string|
  find(:css, '#' + string).click
end


Then("I should see the message {string}") do |string|
  expect(page).to have_content(string)
end

And("I should see the tag {string} on the experiment {string}") do |string, string2|
  expect(page).to have_css('#'+string2, text: string)
end
