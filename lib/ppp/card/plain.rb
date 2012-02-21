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

  def bar
    '-' * (width + 2)
  end

  def width
    return rows.first.join( ' ' ).size if rows.size >= 1
    header.size
  end

  def rows
    codes.each_with_index.collect { |row, i| [ first_column( i ) ] + row }
  end

  def header
    header_cells.join ' '
  end

  def header_cells
    cells = passcodes_per_line.times.collect { |i| column_label(i+1).center code_length }

    [' ' * first_column_width ] + cells
  end

  def title_str
    title = @title[0, width - card_label.size] # trim title if it's too long to fit

    blank_space = width - (title.size + card_label.size)
    title = title + (' ' * blank_space) + card_label
  end

  def card_label
    "[#{card_number}]"
  end

  def split_bar
    parts = ['-' * first_column_width] + (1..passcodes_per_line).collect { '-' * code_length }
    "-#{parts.join '+'}-"
  end

  def row_lines
    rows.collect{ |r| line :pad, r.join( ' ' ) }
  end

  def line pad=:nopad, str
    return "| #{str} |\n" if pad == :pad

    "|#{str}|\n"
  end

  def first_column row_index
    label = row_label row_index
    padding = ' ' * (first_column_width - label.size)
    padding + label
  end

  def first_column_width
    @row_count.to_s.size + 1
  end
end
