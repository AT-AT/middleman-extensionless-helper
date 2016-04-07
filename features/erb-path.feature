Feature: Handle ERb files designated with a relative path.

  Scenario: Build ERb file
    Given a fixture app "erb-path-app"
    And a file named "config.rb" with:
      """
      activate :extensionless_helper do |f|
        f.target = [
          'sub/target.erb',
          'sub/target.txt.erb',
        ]
      end
      set :test_msg, 'CONVERTED'
      """
    And a successfully built app at "erb-path-app"
    When I cd to "build"

    Then a file named "sub/target.html" should not exist
    Then a file named "sub/target" should exist
    Then the file "sub/target" should contain "CONVERTED"

    Then a file named "sub/target.txt" should exist
    Then the file "sub/target.txt" should contain "CONVERTED"

