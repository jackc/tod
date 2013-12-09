# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "tod/version"

Gem::Specification.new do |s|
  s.name        = "tod"
  s.version     = Tod::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jack Christensen"]
  s.email       = ["jack@jackchristensen.com"]
  s.homepage    = "https://github.com/JackC/tod"
  s.summary     = %q{Supplies TimeOfDay and Shift class}
  s.description = %q{Supplies TimeOfDay and Shift class that includes parsing, strftime, comparison, and arithmetic.}

  s.add_development_dependency "test-unit"
  s.add_development_dependency "shoulda"
  s.add_development_dependency "mocha"
  s.add_development_dependency "tzinfo"
  s.add_development_dependency "rake"
  s.add_development_dependency "activerecord", ">= 3.0.0"
  s.add_development_dependency "sqlite3"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
