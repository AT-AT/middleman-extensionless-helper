Feature: Handle ERb files.

  Scenario: Build ERb file
    Given a fixture app "erb-app"
    And a file named "config.rb" with:
      """
      activate :extensionless_helper do |f|
        f.target = [
          # Handle in the following cases.
          '.htaccess.erb',
          'target.erb',
          'target_no_tag.erb',

          # Except, because dot file other than ".htaccess" and ".htpasswd" do not be built.
          '.target.erb',

          # Except, because file has two(src, dest) extensions.
          'target.txt.erb',
          'target_inner_.erb_.erb',
          'target_no_tag.txt.erb',

          # Except, because capitalized extension do NOT produce auto-adding-ext.
          'target_cap.ERB',
        ]
      end
      set :test_msg, 'CONVERTED'
      """
    And a successfully built app at "erb-app"
    When I cd to "build"

    Then a file named ".htaccess" should exist
    Then the file ".htaccess" should contain "CONVERTED"

    Then a file named "target.html" should not exist
    Then a file named "target" should exist
    Then the file "target" should contain "CONVERTED"

    Then a file named "target_no_tag" should exist
    Then the file "target_no_tag" should not contain "CONVERTED"


    Then a file named ".target" should not exist


    Then a file named "target.txt" should exist
    Then the file "target.txt" should contain "CONVERTED"

    Then a file named "target_inner_.erb_" should exist
    Then the file "target_inner_.erb_" should contain "CONVERTED"

    Then a file named "target_no_tag.txt" should exist
    Then the file "target_no_tag.txt" should not contain "CONVERTED"


    Then a file named "target_cap" should exist
    Then the file "target_cap" should contain "CONVERTED"

