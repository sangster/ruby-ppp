require 'ppp/generator'

class Ppp::CardPrinter

  @@CHARS_PER_LINE = 34
  @@SIZES = {:creditcard => %w[ 85.60mm 53.98mm ]}

  def initialize generator, card_title="PPP Passcard", font_size=14, first_card_index=1, size=:creditcard
    @generator  = generator

    raise ArgumentError.new( "Passcodes longer than 16 characters are too long for printing" ) if @generator.length > 16

    @title      = card_title
    @font_size  = font_size
    @card_index = first_card_index
    @size       = process_size size
  end

  def passcodes_per_line
    ( (@@CHARS_PER_LINE + 1) / (@generator.length + 1) ).to_i
  end

  def css
    %[
      <style>
        .card, .card .title, .card .card_index, .card .codes, .card .codes li {
          font-family: monospace;
          font-size: #{@font_size}pt;
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
          <ol>
            #{ (0..15).collect{ "<li>Hi.</li>" }.join(?\n) }
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