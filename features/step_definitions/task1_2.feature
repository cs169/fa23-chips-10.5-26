Feature: task1.2
  As a user
  So that I can find each representatives info

  Scenario: get Dan Sullivan info
    When I am on the home page
    When I click on state "AK"
    Then I should see "Alaska"
    Then I should see "Counties in Alaska"
    When I press "Counties in Alaska"
    Then I should see "Aleutians East Borough"
    When I click on county "Yukon Koyukuk Census Area"
    Then I should see "Dan Sullivan"
    When I follow "Dan Sullivan"
    Then I should see "302 Hart Senate"