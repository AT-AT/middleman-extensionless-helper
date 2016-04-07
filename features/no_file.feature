Feature: Handle a non-existent file.
  In this case, this extension does nothing.

  Scenario: Designated file does not exist
    Given a fixture app "no-file-app"
    And a file named "config.rb" with:
      """
      activate :extensionless_helper do |f|
        f.target = [
          'this_file_does_not_exist.erb',
        ]
      end
      set :test_msg, 'CONVERTED'
      """
    And a successfully built app at "no-file-app"
    When I cd to "build"
    Then a file named "this_file_does_not_exist" should not exist

