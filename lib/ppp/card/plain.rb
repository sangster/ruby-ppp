require 'ppp/card/base'

class Ppp::Card::Plain < Ppp::Card::Base

  def initialize generator, opts={}
    super

    options    = { :row_count => 10 }.merge opts
    @row_count = options[ :row_count ]
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
    @bar ||= '-' * (width + 2)
  end

  def width
    @width ||= begin
      return rows.first.join( ' ' ).size if rows.size >= 1
      header.size
    end
  end

  def rows
    @rows ||= begin
    (1..@row_count).collect do |i|
        [ first_column( i ) ] + (1..passcodes_per_line).collect {next_code}
      end
    end
  end

  def header
    @header ||= header_cells.join ' '
  end

  def header_cells
    [' ' * first_column_width ] + (1..passcodes_per_line).collect do |i|
    (@@FIRST_COLUMN.ord + i-1).chr.center code_length
    end
  end

  def title_str
    @title_str ||= begin
      title = @title[0, width - card_label.size] # trim title if it's too long to fit

      blank_space = width - (title.size + card_label.size)
      title = title + (' ' * blank_space) + card_label
    end
  end

  def card_label
    @card_label ||= "[#{@card_index}]"
  end

  def split_bar
    @split_bar ||= begin
      parts = ['-' * first_column_width] + (1..passcodes_per_line).collect { '-' * code_length }
      "-#{parts.join '+'}-"
    end
  end

  def row_lines
    @row_lines ||= rows.collect{ |r| line :pad, r.join( ' ' ) }
  end

  def line pad=:nopad, str
    return "| #{str} |\n" if pad == :pad

    "|#{str}|\n"
  end

  def first_column row_index
    label = "#{row_index}:"
    padding = ' ' * (first_column_width - label.size)
    padding + label
  end

  def first_column_width
    @first_column_width ||= @row_count.to_s.size + 1
  end
end
