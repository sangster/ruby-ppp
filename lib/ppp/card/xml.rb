require 'ppp/generator'
require 'ppp/card/base'

class Ppp::Card::Xml < Ppp::Card::Base
  def initialize generator, opts={}
    super
  end
  
  def to_s
    rows = codes.each_with_index.collect do |row, i|
      cols = row.each_with_index.collect { |code, j| "    <column label=\"#{column_label(j+1)}\">#{code}</column>" }.join(?\n)
      "  <row number=\"#{i+1}\">\n#{cols}\n  </row>\n"
    end.join(?\n)

    %[<?xml version="1.0" encoding="UTF-8" ?>\n] +
    %[<card title="#{@title}" number="#{card_number}">\n] +
    rows + 
    %[</card>\n]
  end
end