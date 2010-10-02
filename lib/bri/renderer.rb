module Bri
  class Renderer
    INDENT = ' ' * 2

    def initialize
    end

    def render( element, width = Bri.width )
      text = extract_text( element, width )
      styled_text = replace_markup( text )
      element.kind_of?( RDoc::Markup::Verbatim ) ? 
        wrapped_text = styled_text :
        wrapped_text = wrap_to_width( styled_text, width )
      indent( wrapped_text )
    end

    def extract_text( element, width )
      text = case element
               when RDoc::Markup::Paragraph 
                 element.text
               when RDoc::Markup::BlankLine
                 ""
               when RDoc::Markup::Rule
                 "-" * width
               when RDoc::Markup::Verbatim
                 element.text
               when RDoc::Markup::Heading
                 "<h>#{element.text}</h>"
               when RDoc::Markup::ListItem
                 element.label.to_s + element.parts.collect { |part| extract_text part, width }.join
               when RDoc::Markup::List
                 prefix = case element.type
                            when :NOTE, :LABEL then "Note:" 
                            when :NUMBER       then "Numbered List:"
                            when :BULLET       then "Bulletet List:"
                            else 
                              raise "Don't know how to handle list type #{element.type}: #{element.inspect}"
                          end
                 prefix + element.items.collect { |item| extract_text item, width }.join
               else  
                 raise "Don't know how to handle type #{element.class}: #{element.inspect}"
             end
      text + "\n"
    end

    def replace_markup( text )
      text.gsub!( "<tt>", Term::ANSIColor::cyan )
      text.gsub!( "</tt>", Term::ANSIColor::reset )
      text.gsub!( "<h>", Term::ANSIColor::green )
      text.gsub!( "</h>", Term::ANSIColor::reset )
      text
    end

    def wrap_to_width( styled_text, width )
      # Ripped from ActiveSupport
      styled_text.split("\n").collect do |line|
        line.length > width ? 
          line.gsub(/(.{1,#{width}})(\s+|$)/, "\\1\n").strip : 
          line
      end * "\n"
    end

    def indent( text )
      text.split( "\n" ).collect { |row| "#{INDENT}#{row}" }.join("\n" )
    end
  end
end
