Feature: Avoid applying a layout.

  Scenario: There's a layout file
    Given a fixture app "avoid-layout-app"
    And a file named "config.rb" with:
      """
      activate :extensionless_helper do |f|
        f.target = [
          'target.erb',
          'target.txt.erb',
        ]
      end
      set :test_msg, 'CONVERTED'
      """
    And a successfully built app at "avoid-layout-app"
    When I cd to "build"

    Then a file named "target" should exist
    Then the file "target" should contain "CONVERTED"
    Then the file "target" should not contain "html"

    Then a file named "target.txt" should exist
    Then the file "target.txt" should contain "CONVERTED"
    Then the file "target.txt" should not contain "html"

