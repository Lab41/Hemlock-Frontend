Feature: CRUD
  In order to work with valid and invalid models
  All Hemlock Models
  Should accept valid fields and reject invalid arguments

    Scenario: Hemlock Models created without arguments
      Given all models are created without arguments
      Then all models should exist
      
    Scenario: Hemlock Models created with valid arguments
      Given all models exist
      Then all models should exist
      
    Scenario: Hemlock Models created with extra arguments
      Given all models are created with invalid arguments
      Then all models should not exist

      
