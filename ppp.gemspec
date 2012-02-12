# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ppp/version"

Gem::Specification.new do |s|
  s.name        = "ppp"
  s.version     = Ppp::VERSION
  s.authors     = ["Jon Sangster"]
  s.email       = ["jon@ertt.ca"]
  s.homepage    = "http://ertt.ca/"
  s.summary     = %q{Write a gem summary}
  s.description = %q{Write a gem description}

  s.rubyforge_project = "ppp"

  s.files         = %w{ lib/ppp.rb lib/ppp/version.rb }
  #s.files         = `git ls-files`.split("\n")
  #s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  #s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib", "ext"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
