Feature: Handle no target.
  In this case, this extension does nothing.
 
  Scenario: No target is designated
    Given a fixture app "no-target-app"
    And a file named "config.rb" with:
      """
      activate :extensionless_helper
      set :test_msg, 'CONVERTED'
      """
    And a successfully built app at "no-target-app"
    When I cd to "build"

    Then a file named "target.html" should exist
    Then the file "target.html" should contain "CONVERTED"

    Then a file named "target.txt" should exist
    Then the file "target.txt" should contain "CONVERTED"

