# Change below tag(@wip) to anything else when invoke this test.
@wip
Feature: Handle a ruby file.
  This feature(test) is not for the extension, but leave for a examination.
  The Problem:
    MM builds a file by rendering with a template engine.
    If content extension that is acceptable for available template engines is not attached, MM uses ERb.
    However, ERb removes a magic comment of Ruby in ANY file type, like .rb, .txt, .py(!), etc.
    This problem prevents to place ruby script that should not be changed in the source directory. 8-(

  Scenario: A Ruby file is placed in the source directory
    Given a fixture app "ruby-file-app"
    And a successfully built app at "ruby-file-app"
    When I cd to "build"

    Then a file named "target.rb" should exist
    Then the file "target.rb" should contain "# coding: utf-8"

    Then a file named "target.txt" should exist
    Then the file "target.txt" should contain "# coding: utf-8"

