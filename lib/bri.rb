$: << File.dirname( __FILE__ )
require 'bri/mall'
require 'bri/match'
require 'bri/matcher'

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
    matcher = Bri::Matcher.new
    results = matcher.find( query )

    if results.size == 0
      "No matching results found"
    elsif results.size == 1
    else
      formatted_rows = format_elements( results.collect { |result| result.qualified_name }.sort )

      output = []
      output << '------------------------------------------------------ Multiple choices:'
      output << ''
      output << formatted_rows.collect { |row| row.join( ', ' ) }.join( ",\n" )
      output.join( "\n" )
    end
  end

end

