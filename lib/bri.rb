$: << File.dirname( __FILE__ )
require 'bri/mall'
require 'bri/match'
require 'bri/matcher'

module Bri
  def self.format_elements( array )
    width = 72

    rows = []
    row = []
    row_length = 0

    array.each do |element|
      if row_length + element.length + 2 < width
        row << element
        row_length += element.length + 2
      else
        rows << row
        row = [ element ]
        row_length = element.length + 2
      end
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

