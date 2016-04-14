# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$:.unshift(lib) unless $:.include?(lib)
require 'middleman-extensionless-helper/version'

Gem::Specification.new do |s|
  s.name          = 'middleman-extensionless-helper'
  s.version       = Middleman::ExtensionlessHelper::VERSION
  s.platform      = Gem::Platform::RUBY
  s.authors       = ['AT-AT']
  s.email         = ['dec.alpha21264@gmail.com']
  s.homepage      = 'https://github.com/AT-AT/middleman-extensionless-helper'
  s.summary       = %q{A Middleman extension to remove an automatically added content extension}
  s.description   = %q{A Middleman extension to remove an automatically added content extension}
  s.license       = 'MIT'
  s.files         = `git ls-files -z`.split("\0")
  s.test_files    = `git ls-files -- {test,spec,features,fixtures}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
  
  # The version of middleman-core your extension depends on
  s.add_runtime_dependency('middleman-core', ['~> 3.4.1'])
  
  # Additional dependencies
  # None.
end
