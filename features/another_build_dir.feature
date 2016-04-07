Feature: Handle ERb files placed in the another(not default) build directory.

  Scenario: Build ERb file
    Given a fixture app "another-build-dir-app"
    And a file named "config.rb" with:
      """
      activate :extensionless_helper do |f|
        f.target = [
          'target.erb',
          'target.txt.erb',
        ]
      end
      set :test_msg, 'CONVERTED'
      configure :build do
        set :build_dir, %Q!#{config[:build_dir]}_another!
      end
      """
    And a successfully built app at "another-build-dir-app"
    When I cd to "build_another"

    Then a file named "target.html" should not exist
    Then a file named "target" should exist
    Then the file "target" should contain "CONVERTED"

    Then a file named "target.txt" should exist
    Then the file "target.txt" should contain "CONVERTED"

