require 'digest'
require "ppp/version"
require "ppp/generator"
require 'ppp/Cppp'
require 'ppp/card/base'
require 'ppp/card/html'
require 'ppp/card/xml'
require 'ppp/card/plain'

module Ppp
  class << self
    @@ALPHABETS   = { :conservative => '!#%+23456789:=?@ABCDEFGHJKLMNPRSTUVWXYZabcdefghijkmnopqrstuvwxyz',
                      :aggressive   => '!"#$%&\'()*+,-./23456789:;<=>?@ABCDEFGHJKLMNOPRSTUVWXYZ[\]^_abcdefghijkmnopqrstuvwxyz{|}~' }

    # @return [Ppp::Generator] with the given SHA-256 key
    def code_generator key, opts={}
      Generator.new key, opts
    end

    # @param [String] str some string to create a SHA-256 digest of
    # @return a SHA-256 digest of the given string
    def key_from_string str
      Digest::SHA256.new.update( str ).to_s
    end

    # @return a random SHA-256 key
    def random_key
      Cppp.random_key
    end

    # @param [Symbol] type the type of card to return
    # @param [Array] args parameters to pass to the card's constructor
    # @return a [Card] of the given type
    def card type, *args
      case type
      when :html  then return Card::Html.new  *args
      when :xml   then return Card::Xml.new   *args
      when :plain then return Card::Plain.new *args
      end
      raise ArgumentError.new( "%s is not a valid printer style." % style )
    end

   # @return [Hash{Symbol => String}] the default alphabets
    def default_alphabets
      @@ALPHABETS
    end
  end
end
