require 'strscan'

module Bri
  module Renderer
    INDENT = ' ' * 2
    ALPHABET = ('a'..'z').to_a

    def self.render( element, width = Bri.width )
      case element
        when RDoc::Markup::Verbatim 
          text = extract_text( element, width )
          styled_text = replace_markup( text )
          indent( styled_text )

        when RDoc::Markup::List
          item_width = width - INDENT.length
          rendered_items = element.items.collect { |item| render item, item_width }
          rendered_items.map! { |item| item.gsub( /\n/, "\n#{INDENT}" ) }
          case element.type
            when :BULLET 
              rendered_items.map! { |item| ' *' + item }

            when :NUMBER
              i = 0
              rendered_items.map! { |item| i+=1; sprintf "%d.%s", i, item }

            when :LALPHA
              i = -1
              rendered_items.map! { |item| i+=1; sprintf "%s.%s", ALPHABET[i], item }
              
            when :LABEL
              # do nothing

            when :NOTE
              # FIXME: not lined up yet
          end

          rendered_items.join( "\n\n" ) + "\n"

        else
          text = extract_text( element, width )
          styled_text = replace_markup( text )
          wrapped_text = wrap_to_width( styled_text, width )
          indent( wrapped_text )
      end
    end

    def self.extract_text( element, width )
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
                 parts = element.parts.collect { |part| extract_text part, width }.join
                 element.label ? "#{element.label}: #{parts}" : parts
               when RDoc::Markup::List
                 render( element, width - INDENT.length )
               else  
                 raise "Don't know how to handle type #{element.class}: #{element.inspect}"
             end
      text + "\n"
    end

    def self.replace_markup( text )
      text.gsub!( "<tt>", Term::ANSIColor::cyan )
      text.gsub!( "</tt>", Term::ANSIColor::reset )

      text.gsub!( "<code>", Term::ANSIColor::cyan )
      text.gsub!( "</code>", Term::ANSIColor::reset )

      text.gsub!( "<h>", Term::ANSIColor::green )
      text.gsub!( "</h>", Term::ANSIColor::reset )

      text.gsub!( /(^|\s)\+(.*?[a-zA-Z0-9]+.*?)\+/, 
                  "\\1#{Term::ANSIColor::yellow}\\2#{Term::ANSIColor::reset}" )
      text.gsub!( /(^|\s)_(.*?[a-zA-Z0-9]+.*?)_/, 
                  "\\1#{Term::ANSIColor::yellow}\\2#{Term::ANSIColor::reset}" )
      text
    end

    def self.printable_length( text )
      Term::ANSIColor.uncolored( text ).length
    end

    def self.wrap_list( array, width = Bri.width )
      indent( wrap_to_width( array.join(", "), width ) )
    end

    def self.wrap_to_width( styled_text, width )
      styled_text.split( "\n" ).collect { |row| wrap_row row, width }.join
    end

    def self.wrap_row( physical_row, width )
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

    def self.indent( text )
      text.split( "\n" ).collect { |row| "#{INDENT}#{row}" }.join("\n" )
    end
  end
end
