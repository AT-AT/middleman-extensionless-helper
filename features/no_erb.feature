Feature: Handle no ERb file.
  In this case, this extension does nothing.

  Scenario: Build no ERb file
    Given a fixture app "no-erb-app"
    And a file named "config.rb" with:
      """
      activate :extensionless_helper do |f|
        f.target = [
          'target',
          'target.txt',
          'target.erb.txt',
        ]
      end
      set :test_msg, 'CONVERTED'
      """
    And a successfully built app at "no-erb-app"
    When I cd to "build"

    Then a file named "target" should exist
    Then the file "target" should not contain "CONVERTED"

    Then a file named "target.txt" should exist
    Then the file "target.txt" should not contain "CONVERTED"

    Then a file named "target.erb.txt" should exist
    Then the file "target.erb.txt" should not contain "CONVERTED"

