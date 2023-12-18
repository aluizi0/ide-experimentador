 Feature: Add a new experiment and Confirmation 
  @javascript
  Scenario: Add a new experiment (Happy)
    When the user is on the add experiment screen
    And the user clicks on the experiment name field and types "Experiment B1"
    And the user clicks on the factor name field and types "Velocidade"
    And the user clicks on the add factor button
    And the user clicks on the factor name field and types "Temperatura"
    And the user clicks on the add factor button
    And the user clicks on the factor value field and types "10"
    And the user clicks on the button with id "add-to-Velocidade"
    And the user clicks on the factor value field and types "20"
    And the user clicks on the button with id "add-to-Velocidade"
    And the user clicks on the factor value field and types "30"
    And the user clicks on the button with id "add-to-Temperatura"
    And the user clicks on the factor value field and types "40"
    And the user clicks on the button with id "add-to-Temperatura"
    And the user clicks on the create experiment button
    Then the user should see a modal with the experiment details

  @javascript
  Scenario: Add a new experiment (Sad)
    When the user is on the add experiment screen
    And the user dont fill the fields
    And the user clicks on the create experiment button
    Then the user should see the fail message "Erro ao criar o experimento!"
