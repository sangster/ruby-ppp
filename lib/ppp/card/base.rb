require 'ppp/generator'

module Ppp
  module Card
    # @abstract Subclass and override {#to_s} to implement a custom Card class.
    class Base
      attr_reader :card_number, :row_count, :title

      @@CHARS_PER_LINE = 34
      @@FIRST_COLUMN = ?A
      @@ROW_COL_PATTERN = /([[:digit:]]+)([[:alpha:]])/

      @@ERROR_BAD_ROW_COL    = %[Expected a string with exactly one integer followed by one letter, got "%s"]
      @@ERROR_LONG_CODES     = %[Passcodes longer than 16 characters are too long for printing]
      @@ERROR_WRONG_NUM_ARGS = %[Wrong number of arguments. Expected %s, got %d]

      # @param [Generator] generator the generator this card will get passcodes from
      # @param [Hash] opts options to create the card with
      # @option opts [Fixnum] :row_count (10) the number of rows in the card
      # @option opts [String] :card_title ('PPP Passcard') the title of the card
      # @option opts [Fixnum] :first_card_number (1) the number of the first card to create
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

      # @return [Fixnum] the number of characters in each passcode in the card
      def code_length
        @generator.length
      end

      # @param [Fixnum] number the new card number. Must be +1+ or more. The card number determines which passcodes
      #   will be printed on the card. For example, if the card has 10 rows, and each row has five passcodes, then
      #   Card #1 will retrieve passcodes 0-49 from the generator. If +card_number == 2+, then passcodes 50-99 will
      #   be printed from the generator.
      def card_number= number
        raise ArgumentError.new( "card number must be a positive integer" ) if number < 1
        @card_number = number
      end

      # @return [Fixnum] the number of passcodes to be printed on each line
      def passcodes_per_line
        @passcodes_per_line ||= ( (@@CHARS_PER_LINE+1) / (code_length + 1) ).to_i
      end

      # @return [Fixnum] the number of passcodes to be printed on the card
      def passcodes_per_card
        passcodes_per_line * row_count
      end

      # @return [Array(Array(String))] the passcodes on the current card
      def codes
        (1..row_count).collect do |row|
          offset = card_offset + ((row-1) * passcodes_per_line)

          @generator.passcodes offset, passcodes_per_line
        end
      end

      # @overload passcode(cell)
      #   @return [String] the passcode in the given cell
      #   @param [String] cell A cell ID. example: +10B+
      # @overload passcode(row, column)
      #   @return [String] the passcode in the given row and column
      #   @param [Fixnum] row the row of the passcode to return
      #   @param [String] column the column of the passcode to return
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

        offset = row_offset * passcodes_per_line + col_offset
        offset = card_offset + offset
        @generator.passcode offset
      end

      # @overload verify(cell, given_passcode)
      #   @return [Boolean] +true+ if the given passcode matches the passcode in the given cell
      #   @param [String] cell A cell ID. example: +10B+
      #   @param [String] given_passcode the passcode to verify
      # @overload verify(row, column, given_passcode)
      #   @return [Boolean] +true+ if the given passcode matches the passcode in the given row and column
      #   @param [Fixnum] row the row of the passcode to return
      #   @param [String] column the column of the passcode to return
      #   @param [String] given_passcode the passcode to verify
      def verify *args
        given_code = args.pop
        given_code == passcode( *args )
      end

      def to_s
        raise "unimplemented"
      end

      protected

      def row_label row_index
        "#{row_index + 1}:"
      end

      def column_label column_number
        (@@FIRST_COLUMN.ord + (column_number - 1)).chr
      end

      # @return [Fixnum] the offset of passcodes to request from the generator for the given card. For example, if this
      #   card contains 50 passcodes, and we are currently on card 3, we want to request passcodes 100-149 from the
      #   generator.
      def card_offset
        (card_number-1) * passcodes_per_card
      end
    end
  end
end
