require 'ppp/generator'

module Ppp
  module Card
    class Base
      @@CHARS_PER_LINE = 34
      @@FIRST_COLUMN = ?A
      @@ROW_COL_PATTERN = /[[:digit:]][[:alpha:]]/

      @@ERROR_BAD_ROW_COL = %[Expected a string with exactly one digit and one letter, got "%s".]
      @@ERROR_LONG_CODES  = %[Passcodes longer than 16 characters are too long for printing]
      def initialize generator, card_title="PPP Passcard", first_card_index=1
        @generator = generator

        raise ArgumentError.new( @@ERROR_LONG_CODES ) if @generator.length > 16

        @title      = card_title
        @card_index = first_card_index
        @offset     = 0
      end

      def passcodes_per_line
        @passcodes_per_line ||= ( (@@CHARS_PER_LINE+1) / (@generator.length + 1) ).to_i
      end

      def next_code
        code = @generator.passcode( @offset )
        @offset += 1
        code
      end

      def passcode row_col
        raise ArgumentError.new( @@ERROR_BAD_ROW_COL % row_col ) unless row_col.size == 2 && @@ROW_COL_PATTERN.match( row_col.split('').sort.join )
        passcode *row_col.split('')
      end

      def passcode row, col
        col_offset = col.ord - @@FIRST_COLUMN.ord
        row_offset = row - 1

        @generator.passcode row_offset * passcodes_per_line + col_offset
      end
    end
  end
end
