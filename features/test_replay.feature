Feature:  Test WS replay
  I want to test the ability to return a web service call on demand
  As a tester trying to test the application
  So that I can control my test data


  Scenario:  Simple replay
    Given I want a car rental
    When I make a reservation
    Then I should see a car reservation
