Feature: Display Representatives

  Scenario: View a specific representative
    Given there is a representative in the system
    When I visit the representative's page
    Then I should see the details of that representative

  Scenario: Access profile page from search
    Given I visit the search page
    When I search for Fairfax County
    When I click on Joseph R. Biden's link in the search results
    Then I should see Joseph R. Biden's information
