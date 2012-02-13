require 'ppp/generator'

class Ppp::CardPrinter

  @@COLUMN_NAMES = ?A...?Z
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
    ( (@@CHARS_PER_LINE) / (@generator.length + 1) ).to_i
  end
  
  def next_code
    code = @generator.passcode( @offset )
    @offset += 1
    code
  end

  def css
    %[
      <style>
        .card, .card .title, .card .card_index, .card .codes, .card .codes li {
          font-family: monospace;
          font-size: 3.5mm;
        }
        .card {
          background-color: \#fff;
          margin: 0 auto 0 auto;
          width:  #{width};
          height: #{height};
          border: 1px solid \#000;
        }
        .title {
          border-bottom: 1px solid \#aaa;
          background-color: \#eee;
        }
        .card_index {
          float: right;
          margin-right: 1ex;
        }
        .codes {
        }
        .codes ol {
          padding: 0;
          margin: 0;
          margin-left: 3em;
          list-style-position: outside;
        }
        .codes .codes_heading {
          margin-left: 3em;
        }
        .codes .codes_heading .codes_column {
          text-align: center;
          width: #{@generator.length}em;
        }
      </style>
    ]
  end

  def html
    %[
      <div class="card">
        <div class="title">
        #{@title}
        <span class="card_index">#{@card_index}</span>
        </div>
        <div class="codes">
          <div class="codes_heading">
            #{ @@COLUMN_NAMES.first(passcodes_per_line).collect { |c| %[<span class="codes_column">#{c}</span>] }.join ?\n }
          </div>
          <ol>
            #{ (0..9).collect{ "<li>#{(0..passcodes_per_line).collect {next_code}.join(' ') }</li>" }.join(?\n) }
          </ol>
        </div>
      </div>
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