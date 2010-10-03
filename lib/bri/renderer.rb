require 'strscan'

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
                            when :NOTE, :LABEL then "Note:\n" 
                            when :NUMBER       then "Numbered List:\n"
                            when :BULLET       then "Bulletet List:\n"
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

      text.gsub!( "<code>", Term::ANSIColor::cyan )
      text.gsub!( "</code>", Term::ANSIColor::reset )

      text.gsub!( "<h>", Term::ANSIColor::green )
      text.gsub!( "</h>", Term::ANSIColor::reset )

      text.gsub!( /(^\s)\+(.*?)\+(\s|$)/, 
                  "\\1#{Term::ANSIColor::yellow}\\2#{Term::ANSIColor::reset}\\3" )
      text.gsub!( /(^|\s)_(.*?)_(\s|$)/, 
                  "\\1#{Term::ANSIColor::yellow}\\2#{Term::ANSIColor::reset}\\3" )
      text
    end

    def printable_length( text )
      embedded_ansi_codes = text.scan( Term::ANSIColor::COLORED_REGEXP )
      if embedded_ansi_codes.empty?
        text.length
      else
        text.length - embedded_ansi_codes.reduce( 0 ) { |total, code| code.length + total }
      end
    end

    def wrap_to_width( styled_text, width )
      styled_text.split( "\n" ).collect { |row| wrap_row row, width }.join
    end

    def wrap_row( physical_row, width )
      output_text = ''
      logical_row = ''
      printable_row_length = 0

      scanner = StringScanner.new( physical_row )

      while( !scanner.eos? ) 
        token = scanner.scan( /\S+/ ).to_s
        printable_token_length = printable_length( token )

        if printable_token_length + printable_row_length > width
          output_text << logical_row << "\n"
          logical_row = ''
          printable_row_length = 0
        end
        logical_row << token
        printable_row_length += printable_token_length

        token = scanner.scan( /\s*/ ).to_s
        logical_row << token
        printable_row_length += token.length
      end
      output_text << logical_row << "\n"
    end

    def indent( text )
      text.split( "\n" ).collect { |row| "#{INDENT}#{row}" }.join("\n" )
    end
  end
end
