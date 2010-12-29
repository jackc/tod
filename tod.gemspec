# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "tod/version"

Gem::Specification.new do |s|
  s.name        = "tod"
  s.version     = TimeOfDay::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jack Christensen"]
  s.email       = ["jack@jackchristensen.com"]
  s.homepage    = ""
  s.summary     = %q{Time of day class}
  s.description = %q{Time of day class includes parsing, strftime, comparison, and arithmetic.}

  s.rubyforge_project = "tod"

  s.add_development_dependency "test-unit"
  s.add_development_dependency "shoulda"
  s.add_development_dependency "mocha"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
