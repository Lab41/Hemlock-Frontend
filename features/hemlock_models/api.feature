Feature: API
  In order to work with the Hemlock API
  All hemlock models
  Should query and return valid results

    Scenario: Hemlock Models query API for list results
      Given all models exist
      And all models query the API for list results
      Then list API calls should return valid results
      
    Scenario: Hemlock Models query API for a single result
      Given all models exist
      And all models query the API for a single result
      Then single API calls should return valid results
      
    Scenario: Hemlock Models query API for sublist results
      Given all models exist
      And all models query the API for associated sublist results
      Then list API calls should return valid results

      
