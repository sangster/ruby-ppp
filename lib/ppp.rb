require "ppp/version"

require 'digest'

module Ppp
  class << self
    def hash_from_string str
      Digest::SHA256.new.update( str ).to_s
    end
  end
end
