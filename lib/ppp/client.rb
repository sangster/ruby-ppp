class Ppp::Client
  
  @@pppv2_alphabet = "!#%+23456789=:?@ABCDEFGHJKLMNPRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
  
  def initialize sha256_key, alphabet=@@pppv2_alphabet
    raise "expected a Bignum, got a #{sha256_key.class}" unless sha256_key.is_a?( Bignum )

    @key      = sha256_key
    @alphabet = alphabet
  end
  
end