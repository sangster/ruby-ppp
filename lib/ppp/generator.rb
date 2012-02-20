require 'ppp/Cppp'

# Generates passcodes.
class Ppp::Generator
  attr_reader :seed, :length, :alphabet

  @@HEX_PATTERN = /[a-fA-F0-9]{64}/

  # @param [String] sha256_key a 64 hex-digit string representation of a
  #   SHA-256 hash. This hash will seed all the generated passcodes.
  # @param [Fixnum] length the number of characters in each generated passcode
  # @param [String] alphabet a string containing the characters passcodes will
  #   be comprised of. Cannot contain null characters and duplicate characters
  #   will be removed.
  def initialize sha256_key, opts={}
    raise NotHexKey.new( sha256_key ) if @@HEX_PATTERN.match( sha256_key ).nil?

    @seed     = sha256_key

    options   = { :length => 4, :alphabet => :conservative }.merge opts
    @length   = options[ :length ]
    @alphabet = process_alphabet( options[ :alphabet ] ).split( '' ).uniq.join

    raise ArgumentError.new( "alphabet cannot contain null character" ) if alphabet.include? ?\0
  end

  # Creates passcodes seeded off the SHA-256 key this object was created with.
  #   Calling this method subsequent times with the same offset will return the
  #   same passcodes, so you should increase the offset by count each time.
  # @param [Fixnum] offset the number of passcodes to skip
  # @param [Fixnum] count the number of passcodes to return
  # @return [Array] an array of passcodes
  def passcodes offset, count
    Cppp.passcodes @seed, offset, count, @length, @alphabet
  end

  # (@see #passcodes)
  def passcode offset
    passcodes( offset, 1 ).first
  end

  # Check if a given passcode is correct
  # @param [Fixnum] index the index of the passcode to check against
  # @return [Boolean] if the given passcode matches the passcode at the given offset
  def verify index, given_passcode
    passcode( index ) == given_passcode
  end

  private

  def process_alphabet alphabet
    case alphabet
    when Symbol
      return Ppp.default_alphabets[ alphabet ] if Ppp.default_alphabets.include? alphabet
      raise ArgumentError.new( %[No alphabet for for symbol "#{alphabet}"] )
    when String
      return alphabet
    else
    raise ArgumentError.new( "Alphabet must be a Symbol or String" )
    end
  end

  class NotHexKey < ArgumentError
    @@error = 'Expected a 64 digit hex-string, but got "%s". Use Ppp.key_from_string() to generate a useable hex-string from an arbitrary string.'
    def initialize( key ) @key = key     end

    def to_s()            @@error % @key end
  end
end
