require 'ppp/generator'
require 'ppp/card/base'

class Ppp::Card::Html < Ppp::Card::Base
  @@SIZES = {:creditcard => %w[ 85.60mm 53.98mm ]}

  def initialize generator, opts={}
    super

    options    = { :font_size => 14, :size => :creditcard }.merge opts
    @font_size = options[ :font_size ]
    @size      = process_size options[ :size ]
  end

  def css
    %[
      <style>
        .card, .card .title, .card .card_number, .card .codes, .card .codes td {
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
        .card_number {
          float: right;
          margin-right: 1ex;
        }
        .card_number:before { content: '['; }
        .card_number:after  { content: ']'; }

        .codes_heading th {
          text-align: center;
          width: #{code_length}em;
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
    rows = codes.each_with_index.collect do |row, i|
      cols = row.collect { |code| "  <td>#{code}</td>" }.join(?\n)
      "<tr>\n  <td>#{i+1}:</td>\n#{cols}</tr>"
    end.join(?\n)

    %[
      <table class="card">
        <caption class="title">
          #{@title}
          <span class="card_number">#{card_number}</span>
        </caption>
        <colgroup span="1">
        <colgroup span="#{passcodes_per_line}">
        <thead class="codes_heading">
          <th>&nbsp;</th>
          #{ (0..passcodes_per_line-1).collect { |i| %[<th>#{(@@FIRST_COLUMN.ord + i).chr}</th>] }.join ?\n }
        </thead>
        <tbody class="codes">
          #{rows}
        </tbody>
      </table>
    ]
  end

  def to_s
    "#{css}\n\n#{html}"
  end

  protected # ----------------------------------------------

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