require 'digest'
require "ppp/version"
require "ppp/client"
require 'ppp/Cppp'

module Ppp
  class << self
    def new key
      client = Client.new key
    end

    def key_from_string str
      Digest::SHA256.new.update( str ).to_s
    end

    def random_key
      Cppp.random_key
    end
  end
end
