# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ppp/version"

Gem::Specification.new do |s|
  s.name        = "ppp"
  s.version     = Ppp::VERSION
  s.authors     = ["Jon Sangster"]
  s.email       = ["jon@ertt.ca"]
  s.homepage    = "http://ertt.ca/"
  s.summary     = %q{Ruby interface for John Graham-Cumming's implementation of GRC's Open, Ultra-High Security, One Time Password System}
  s.description = <<-EOF
    At grc.com/ppp.htm Steve Gibson describes a system for generating one-time passcodes. The rational for such a sytem is
    given:
    "The trouble with a username and password is that they never change. We create them, write them down or memorize them, then
    use them over and over again. What has been needed is an inexpensive system that provides something which changes everytime
    it is used. GRC's Perfect Paper Passwords system offers a simple, safe and secure, free and well documented solution that
    is being adopted by a growing number of security-conscious Internet facilities to provide their users with state-of-the-art
    cryptographic logon security."

    John Graham-Cumming has provided an open-source implementation of this system in C (http://www.jgc.org/blog/pppv3-c.zip),
    released under the BSD license.

    This gem is a ruby interface to that C implementation.
  EOF

  s.rubyforge_project = "ppp"

  s.require_paths = ["lib", "ext"]
  s.files         = %w{ LICENSE lib/ppp.rb lib/ppp/version.rb lib/ppp/generator.rb lib/ppp/card_printer.rb } + Dir.glob( 'ext/**/*.{c,h,rb}' )
  s.extensions    = [ 'ext/ppp/extconf.rb' ]
  #s.files         = `git ls-files`.split("\n")
  #s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  #s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
