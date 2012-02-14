require 'ppp/generator'

class Ppp::CardPrinter

  @@FIRST_COLUMN = ?A
  @@CHARS_PER_LINE = 34
  @@SIZES = {:creditcard => %w[ 85.60mm 53.98mm ]}

  def initialize generator, card_title="PPP Passcard", font_size=14, first_card_index=1, size=:creditcard
    @generator  = generator

    raise ArgumentError.new( "Passcodes longer than 16 characters are too long for printing" ) if @generator.length > 16

    @title      = card_title
    @font_size  = font_size
    @card_index = first_card_index
    @size       = process_size size
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

  def css
    %[
      <style>
        .card, .card .title, .card .card_index, .card .codes, .card .codes td {
          font-family: monospace;
          font-size: 3.5mm;
        }
        .card {
          background-color: \#fff;
          margin: 0 auto 0 auto;
          width:  #{width};
          height: #{height};
          border: 1px solid \#000;
          border-top: none;
          border-spacing: 0;
        }
        .title {
          border: 1px solid \#000;
          border-bottom: 1px solid \#000;
          background-color: \#eee;
          text-align: left;
          padding-left: 1ex;
          font-weight: bold;
        }
        .title td:first-child {
          width: 2.5em;
        }
        .card_index {
          float: right;
          margin-right: 1ex;
        }
        .card_index:before { content: '['; }
        .card_index:after  { content: ']'; }

        .codes_heading th {
          text-align: center;
          width: #{@generator.length}em;
          border-bottom: 1px solid \#aaa;
          background-color: \#eee;
        }
        .codes_heading th:first-child {
          background-color: \#fff;
          border-right: 1px solid \#aaa;
        }
        .codes_heading th:last-child  { border-right:  none; }
        .codes td {
          padding: 0;
          margin: 0;
          text-align: center;
          border-right: 1px solid \#aaa;
          border-bottom: 1px solid \#aaa;
        }
        .codes tr td:first-child {
          text-align: right;
          padding-right: 0.5em;
          font-weight: bold;
          background-color: \#eee;
          border-right: 1px solid \#aaa;
        }
        .codes tr td:first-child { border-bottom: none; }
        .codes tr td:last-child  { border-right:  none; }
        .codes tr:last-child td  { border-bottom: none; }
      </style>
    ]
  end

  def html
    %[
      <table class="card">
        <caption class="title">
          #{@title}
          <span class="card_index">#{@card_index}</span>
        </caption>
        <colgroup span="1">
        <colgroup span="#{passcodes_per_line}">
        <thead class="codes_heading">
          <th>&nbsp;</th>
          #{ (0..passcodes_per_line-1).collect { |i| %[<th>#{(@@FIRST_COLUMN.ord + i).chr}</th>] }.join ?\n }
        </thead>
        <tbody class="codes">
          #{ (1..9).collect { |i| "<tr><td>#{i}</td>#{(1..passcodes_per_line).collect {%[<td>#{next_code}</td>]}.join(?\n) }</tr>" }.join(?\n) }
        </tbody>
      </table>
    ]
  end

  protected
  
  def width
    @size[0]
  end
  
  def height
    @size[1]
  end

  def process_size size
    case size
    when Symbol
      return @@SIZES[ size ] if @@SIZES.include? size
      raise ArgumentError.new( %[No card size for symbol "#{size}"] )
    when Array
      return [ size[0].to_s, size[1].to_s ]
    else
      raise ArgumentError.new( "Size must be a Symbol or Array" )
    end
  end
end