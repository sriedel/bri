$: << File.dirname( __FILE__ )
require 'erb'
require 'term/ansicolor'


require 'bri/mall'
require 'bri/matcher'
require 'bri/templates'
require 'bri/search'
require 'bri/match'

module Bri
  DEFAULT_WIDTH = 72

  def self.format_elements( array )
    rows = []
    row = []
    row_length = 0

    array.each do |element|
      element_length_with_separator = element.length + 2

      if row_length + element_length_with_separator >= Bri.width
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
      results.first.to_s
    else
      qualified_methods = results.collect{ |result| result.full_name }.sort
      ERB.new( Bri::Templates::MULTIPLE_CHOICES, nil, '<>' ).result( binding )
    end
  end

  def self.width
    @@width ||= [ ( ENV['COLUMNS'] || 80 ) - 8, 1 ].max
  end

  def self.width=( width )
    @@width = [ width, 1 ].max
  end

  def self.list_classes
    Bri::Mall.instance.classes.join("\n" )
  end

  def self.list_methods
    ( Bri::Mall.instance.instance_methods + 
      Bri::Mall.instance.class_methods ).sort.join( "\n" )
  end

  def self.list_names
    ( Bri::Mall.instance.classes +
      Bri::Mall.instance.instance_methods +
      Bri::Mall.instance.class_methods ).sort.join( "\n" )
  end

end

