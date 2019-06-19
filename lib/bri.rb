require 'erb'
require 'term/ansicolor'

require_relative 'bri/renderer'
require_relative 'bri/mall'
require_relative 'bri/matcher'
require_relative 'bri/templates'
require_relative 'bri/search'
require_relative 'bri/match'

module Bri
  DEFAULT_WIDTH = 72

  def self.ri( query, show_all: false )
    results = Bri::Matcher.new( query ).find

    if results.size == 0
      "No matching results found"
    elsif results.size == 1
      results.first.to_s
    elsif results.all? { |r| r.is_a?(Bri::Match::Class) }
      if show_all
        results.map(&:to_s)
      else
        gem_docs, core_docs = results.partition { |r| r.origin =~ %r{gem\b} }

        docs_to_output = core_docs.empty? ? gem_docs : core_docs
        docs_to_output.map(&:to_s)
      end
    else
      qualified_methods = results.map(&:full_name).sort
      ERB.new( Bri::Templates::MULTIPLE_CHOICES, nil, '<>' ).result( binding )
    end
  end

  def self.width
    return @width if instance_variable_defined?( :@width )

    base_width = ENV['COLUMNS'].to_i 
    base_width = 80 if base_width == 0

    @width ||= [ base_width - 8, 1 ].max
  end

  def self.width=( width )
    @width = [ width, 1 ].max
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

