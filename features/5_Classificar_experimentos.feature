Feature: Classify experiments with tags
  @javascript
  Scenario: Add tag to experiment (Happy)
    Given I am on the "/experiment/classification" page
    When I click on the tag with id "tag-2"
    And I click on the add button with id "add-tag-1"
    Then I should see the message "Tag adicionada com sucesso!"
    And I should see the tag "Tag 2" on the experiment "experiment-1-tags"

  @javascript
  Scenario: Add tag to experiment without selecting a tag (Sad)
    Given I am on the "/experiment/classification" page
    And I click on the add button with id "add-tag-1"
    Then I should see the message "Erro ao adicionar tag!"