require 'ppp/generator'

module Ppp
  module Card
    class Base
      attr_reader :card_number, :row_count, :title

      @@CHARS_PER_LINE = 34
      @@FIRST_COLUMN = ?A
      @@ROW_COL_PATTERN = /([[:digit:]]+)([[:alpha:]])/

      @@ERROR_BAD_ROW_COL    = %[Expected a string with exactly one integer followed by one letter, got "%s"]
      @@ERROR_LONG_CODES     = %[Passcodes longer than 16 characters are too long for printing]
      @@ERROR_WRONG_NUM_ARGS = %[Wrong number of arguments. Expected %s, got %d]

      def initialize generator, opts={}
        @generator = generator
        raise ArgumentError.new( @@ERROR_LONG_CODES ) if code_length > 16

        options = { :row_count         => 10,
                    :card_title        => 'PPP Passcard',
                    :first_card_number => 1 }
        options.merge! opts
        @title       = options[ :card_title        ]
        @row_count   = options[ :row_count         ]
        @card_number = options[ :first_card_number ]
      end

      def code_length
        @generator.length
      end

      def card_number= number
        raise ArgumentError.new( "card number must be a positive integer" ) if number < 1
        @card_number = number
      end

      def passcodes_per_line
        @passcodes_per_line ||= ( (@@CHARS_PER_LINE+1) / (code_length + 1) ).to_i
      end

      def passcodes_per_card
        passcodes_per_line * row_count
      end

      def codes
        (1..row_count).collect do |row|
          card_offset = (card_number-1) * passcodes_per_card
          offset = card_offset + ((row-1) * passcodes_per_line)

          @generator.passcodes offset, passcodes_per_line
        end
      end

      def passcode *args
        case args.size
        when 1
          match = @@ROW_COL_PATTERN.match( args.first )
          raise ArgumentError.new( @@ERROR_BAD_ROW_COL % args.first ) unless match
          row = match[1]
          col = match[2]
        when 2
          (row, col) = args
        else
          raise ArgumentError.new( @@ERROR_WRONG_NUM_ARGS % ['1 or 2', args.size] )
        end

        col_offset = col.ord - @@FIRST_COLUMN.ord
        row_offset = row.to_i - 1

        @generator.passcode row_offset * passcodes_per_line + col_offset
      end

      def verify *args
        given_code = args.pop
        given_code == passcode( *args )
      end

      def row_label row_number
        "#{row_number + 1}:"
      end

      def column_label column_number
        (@@FIRST_COLUMN.ord + (column_number - 1)).chr
      end
    end
  end
end
