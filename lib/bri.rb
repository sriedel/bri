$: << File.dirname( __FILE__ )
require 'erb'

require 'bri/mall'
require 'bri/match'
require 'bri/matcher'
require 'bri/templates'
require 'bri/class_search'

module Bri
  WIDTH = 72

  def self.format_elements( array )
    rows = []
    row = []
    row_length = 0

    array.each do |element|
      element_length_with_separator = element.length + 2

      if row_length + element_length_with_separator >= WIDTH
        rows << row
        row = []
        row_length = 0
      end

      row << element
      row_length += element_length_with_separator
    end

    rows << row
    rows
  end

  def self.ri( query )
    results = Bri::Matcher.new( query ).find

    if results.size == 0
      "No matching results found"
    elsif results.size == 1
    else
      qualified_methods = results.collect{ |result| result.qualified_name }.sort
      ERB.new( Bri::Templates::MULTIPLE_CHOICES, nil, '<>' ).result( binding )
    end
  end

end

