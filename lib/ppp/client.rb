require 'ppp/Cppp'

class Ppp::Client
  @@HEX_PATTERN = /[a-fA-F0-9]{64}/
  @@PPPV2_ALPHABET = "!#%+23456789=:?@ABCDEFGHJKLMNPRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
  
  def initialize sha256_key, length=4, alphabet=@@PPPV2_ALPHABET
    raise "Expected a 64 digit hex-string, got \"#{key}\"" if @@HEX_PATTERN.match( sha256_key ).nil?

    @key      = sha256_key
    @length   = length
    @alphabet = alphabet
  end
  
  def passcodes offset, count
    Cppp.passcodes @key, offset, count, @length, @alphabet
  end
  
  def passcode offset
    passcodes( offset, 1 ).first
  end
  
  def verify offset, given_passcode
    passcode( offset ) == given_passcode
  end
end
