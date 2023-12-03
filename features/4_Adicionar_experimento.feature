Feature: Add a new experiment
  @javascript
  Scenario: Add a new experiment (Happy)
    When the user is on the add experiment screen
    And the user clicks on the experiment name field and types "Experiment A"
    And the user clicks on the factor name field and types "Factor 1"
    And the user clicks on the add factor button
    And the user clicks on the factor value field and types "Value 1"
    And the user clicks on the add value button
    And the user clicks on the create experiment button
    Then the user should see the message "Experimento criado com sucesso!"

  @javascript
  Scenario: Add a new experiment (Sad)
    When the user is on the add experiment screen - fail
    And the user dont fill the fields
    And the user tries to clicks on the create experiment button
    Then the user should see the fail message "Erro ao criar o experimento!"