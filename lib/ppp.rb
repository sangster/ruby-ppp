require "ppp/version"

require 'digest'

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
  end
end
