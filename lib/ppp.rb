require 'digest'
require "ppp/version"
require 'ppp/Cppp'

module Ppp
  class << self
    @@HEX_PATTERN = /[a-fA-F0-9]{64}/
    def new key
      if @@HEX_PATTERN.match( key ).nil?
        raise "Expected a 64 digit hex-string, got \"#{key}\""
      end
      puts "<#{key.hex}>"
    end

    def hash_from_string str
      Digest::SHA256.new.update( str ).to_s
    end

    def random_key
      Cppp.random_key
    end
  end
end
