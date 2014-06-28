Feature: Test

  Scenario: Test
    Given Connection Establishment
    Given Application Reset
    Then Confirm MainController
    Then Method BOOL Test
    Then Method Double Test
    Then Method Float Test
    Then Method Int Test
    Then Method UInt Test
    Then Method String Test
    Then Method 2 Arguments Test "1" "2"
    Given Change BackgroundColor "red"
    Then Get Instance BOOL Test "false"
    Given Set Instance BOOL Test "true"
    Then Get Instance BOOL Test "true"
    Then Get Instance Double Test "1.23456789012"
    Given Set Instance Double Test "1.23456789"
    Then Get Instance Double Test "1.23456789"
    Then Get Instance Float Test "1.2345"
    Given Set Instance Float Test "2.2345"
    Then Get Instance Float Test "2.2345"
    Then Get Instance Int Test "1234567890"
    Given Set Instance Int Test "1234"
    Then Get Instance Int Test "1234"
    Then Get Instance UInt Test "2240"
    Given Set Instance UInt Test "1210"
    Then Get Instance UInt Test "1210"
    When MainIndexTab Switch To "1"
    Then Confirm MainIndexTab "1"
    Given Go to PatternB_2
    Given Change Label text "Hello World"
    Given Connection Release

