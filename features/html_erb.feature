Feature: Handle a ERb file for HTML.
  In this case, this extension does nothing.

  Scenario: Build HTML from ERb file
    Given a fixture app "html-erb-app"
    And a file named "config.rb" with:
      """
      activate :extensionless_helper do |f|
        f.target = [
          'target.html.erb',
        ]
      end
      set :test_msg, 'CONVERTED'
      """
    And a successfully built app at "html-erb-app"
    When I cd to "build"

    Then a file named "target.html" should exist
    Then the file "target.html" should contain "CONVERTED"

