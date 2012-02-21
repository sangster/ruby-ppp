require 'ppp/card/base'

class Ppp::Card::Plain < Ppp::Card::Base

  def initialize generator, opts={}
    super
  end

  def to_s
    line( bar )             +
    line( :pad, title_str ) +
    line( split_bar )       +
    line( :pad, header )    +
    row_lines.join( '' )    +
    line( split_bar )
  end

  private

  # @return [String] a horizontal rule
  def bar
    '-' * (width + 2)
  end

  # @return [Fixnum] the width of the table
  def width
    return rows.first.join( ' ' ).size if rows.size >= 1
    header.size
  end

  # @return [Array(Array(String))] The cells of the table, with the first column containing the row labels
  def rows
    codes.each_with_index.collect { |row, i| [ first_column( i ) ] + row }
  end

  # @return [String] the column labels
  def header
    header_cells.join ' '
  end

  # @return [Array(String)] a list of the column headers
  def header_cells
    cells = passcodes_per_line.times.collect { |i| column_label(i+1).center code_length }

    [' ' * first_column_width ] + cells
  end

  # @return [String] a line containing the title and card number
  def title_str
    title = @title[0, width - card_label.size] # trim title if it's too long to fit

    blank_space = width - (title.size + card_label.size)
    title = title + (' ' * blank_space) + card_label
  end

  # @return [String] a label containing the card number
  def card_label
    "[#{card_number}]"
  end

  # @return [String] a horizontal rule with notches in it to deliniate the columns
  def split_bar
    parts = ['-' * first_column_width] + (1..passcodes_per_line).collect { '-' * code_length }
    "-#{parts.join '+'}-"
  end

  # @return [Array(String)] a list of rows, each element containing the string of passcodes for that rows
  def row_lines
    rows.collect{ |r| line :pad, r.join( ' ' ) }
  end

  # @return [String] a line with the table's left and right border
  # @param [String] str the content of the line
  # @param [Symbol] +:pad+ if borders should have a one-space padding
  def line pad=:nopad, str
    return "| #{str} |\n" if pad == :pad

    "|#{str}|\n"
  end

  # @return [String] the content of the first cell of the given row. The row's label
  # @param [Fixnum] The index of the given row.
  def first_column row_index
    label = row_label row_index
    padding = ' ' * (first_column_width - label.size)
    padding + label
  end

  # @return [Fixnum] the required number of characters needed to fit the row label of each row
  def first_column_width
    @row_count.to_s.size + 1
  end
end
