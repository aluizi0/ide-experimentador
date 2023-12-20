When("the user is on the add experiment screen") do
  visit '/experiment/create'
end

And("the user clicks on the experiment name field and types {string}") do |string|
  fill_in 'experimentName', with: string
end

And("the user clicks on the factor name field and types {string}") do |string|
  fill_in 'factorName', with: string
end

And("the user clicks on the add factor button") do
  click_button 'addFactor'
end

And("the user clicks on the factor value field and types {string}") do |string|
  fill_in 'factorValue', with: string
end

And("the user clicks on the button with id {string}") do |string|
  find(:css, '#' + string).click
end

And("the user types {string} on the factor input field {string}") do |string, string2|
  fill_in string2, with: string
end

And("the user clicks on the robots name field and types {string}") do |string|
  fill_in 'robotName', with: string
end

And("the user clicks on the add robot button") do
  click_button 'addRobot'
end

And("the user clicks on the create experiment button") do
  click_button 'createExperiment'
end

Then('the user should see a modal with the experiment details') do
  expect(page).to have_content('Experimento criado')
  expect(page).to have_content('Experiment B1')
  expect(page).to have_content('Ensaio 10-30')
  expect(page).to have_content('Ensaio 10-40')
  expect(page).to have_content('Ensaio 20-30')
  expect(page).to have_content('Ensaio 20-40')
  expect(page).to have_content('Robot 1')
end

And("the user dont fill the fields") do
  fill_in 'experimentName', with: ''
  fill_in 'factorName', with: ''
end

Then("the user should see the fail message {string}") do |string|
  expect(page).to have_content(string)
end
