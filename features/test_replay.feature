Feature:  Test WS replay
  I want to test the ability to return a web service call on demand
  As a tester trying to test the application
  So that I can control my test data

  Background:
    Given I setup my replay service

  Scenario:  Simple replay
    Given I want a car rental
    When I make a reservation
    Then I should see a car reservation

  Scenario:  Replay with subsititution
    Given I want a car rental with a "City" of "ATL"
    When I make a reservation
    Then I should see a car reservation with a "City" of "ATL"

