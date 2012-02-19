require 'digest'
require "ppp/version"
require "ppp/generator"
require 'ppp/Cppp'
require 'ppp/card/base'
require 'ppp/card/html'

module Ppp
  class << self
    @@ALPHABETS   = { :conservative => '!#%+23456789:=?@ABCDEFGHJKLMNPRSTUVWXYZabcdefghijkmnopqrstuvwxyz',
                      :aggressive   => '!"#$%&\'()*+,-./23456789:;<=>?@ABCDEFGHJKLMNOPRSTUVWXYZ[\]^_abcdefghijkmnopqrstuvwxyz{|}~' }

    # @return [Ppp::Generator] with the given SHA-256 key
    def new key, length=4, alphabet=@@ALPHABETS[:conservative]
      Generator.new key, length, alphabet
    end

    # @return a SHA-256 digest of the given string
    def key_from_string str
      Digest::SHA256.new.update( str ).to_s
    end

    # @return a random SHA-256 key
    def random_key
      Cppp.random_key
    end

    def printer style, ppp
      case style
      when :html  then return Card::Html.new  ppp
      when :plain then return Card::Plain.new ppp
      end
    end
  end
end
