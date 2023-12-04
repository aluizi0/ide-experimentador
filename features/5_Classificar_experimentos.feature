Feature: Classify experiments with tags
  @javascript
  Scenario: Add tag to experiment
    Given I am on the "/experiment/classification" page
    When I select tag with id "tag-2"
    Then I should see the tag "Tag adicionada com sucesso!"