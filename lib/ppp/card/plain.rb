
class Ppp::Card::Plain < Ppp::Card::Base
  
  def initialize generator, card_title="PPP Passcard", first_card_index=1
    super
  end
  
  def to_s
    %[
          #{@title}
          #{@card_index}
          #{ (0..passcodes_per_line-1).collect { |i| (@@FIRST_COLUMN.ord + i).chr }.join '   ' }
          #{ (1..9).collect { |i| "#{i}:   #{(1..passcodes_per_line).collect {next_code}.join('   ') }" }.join(?\n) }
    ]
  end
end