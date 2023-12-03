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

And("the user clicks on the add value button") do
  find(:css, '.trail-row .botao-responsivo').click
end

And("the user clicks on the create experiment button") do
  click_button 'createExperiment'
end

Then("the user should see the message {string}") do |string|
  expect(page).to have_content(string)
end

When("the user is on the add experiment screen - fail") do
  visit '/experiment/create'
end

And("the user dont fill the fields") do 
  fill_in 'experimentName', with: ''
  fill_in 'factorName', with: ''
  fill_in 'factorValue', with: ''
end

And("the user tries to clicks on the create experiment button") do
  click_button 'createExperiment'
end
 
Then("the user should see the fail message {string}") do |string|
  expect(page).to have_content(string)
end