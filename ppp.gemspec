# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ppp/version"

Gem::Specification.new do |s|
  s.name        = "ppp"
  s.version     = Ppp::VERSION
  s.authors     = ["Jon Sangster"]
  s.email       = ["jon@ertt.ca"]
  s.homepage    = "http://ertt.ca/"
  s.summary     = %q{Ruby bindings for John Graham-Cumming's implementation of GRC's Perfect Paper Passwords}
  s.description = "Ruby-PPP is a Ruby language binding of PPP (Perfect Paper Passwords). " +
                  "PPP is a library designed to create one-time passwords, described at http://grc.com/ppp.htm"

  s.rubyforge_project = "ppp"

  s.require_paths = ["lib", "ext"]
  s.files         = %w{ LICENSE lib/ppp.rb } + Dir.glob( 'lib/ppp/*.rb' ) + Dir.glob( 'lib/ppp/card/*.rb' ) + Dir.glob( 'ext/**/*.{c,h,rb}' )
  s.extensions    = [ 'ext/ppp/extconf.rb' ]
end
