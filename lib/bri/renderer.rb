require 'strscan'

module Bri
  module Renderer
    INDENT = ' ' * 2
    INDENT_WIDTH = 2
    LOWER_ALPHABET = ('a'..'z').to_a.map { |char| "#{char}." }.freeze
    UPPER_ALPHABET = ('A'..'Z').to_a.map { |char| "#{char}." }.freeze

    def self.render( element, width = Bri.width, alignment_width = 0 )
      case element
        when RDoc::Markup::Verbatim 
          text = extract_text( element, width )
          styled_text = replace_markup( text )
          "#{indent( styled_text )}\n"

        when RDoc::Markup::List
          item_width = width - INDENT_WIDTH
          case element.type
            when :BULLET 
              rendered_items = element.items.map { |item| render( item, item_width ) }
              rendered_items.map! { |item| item.gsub( /\n/, "\n#{INDENT}" ) }
              rendered_items.map! { |item| item.prepend( ' *' ) }

            when :NUMBER
              rendered_items = element.items.map { |item| render( item, item_width ) }
              rendered_items.map! { |item| item.gsub( /\n/, "\n#{INDENT}" ) }
              rendered_items.map!.with_index( 1 ) { |item, i| item.prepend( "#{i}." ) }

            when :LALPHA
              rendered_items = element.items.map { |item| render( item, item_width ) }
              rendered_items.map! { |item| item.gsub( /\n/, "\n#{INDENT}" ) }
              rendered_items.map!.with_index { |item, i| item.prepend( LOWER_ALPHABET[i] ) }

            when :UALPHA
              rendered_items = element.items.map { |item| render( item, item_width ) }
              rendered_items.map! { |item| item.gsub( /\n/, "\n#{INDENT}" ) }
              rendered_items.map!.with_index { |item, index| item.prepend( UPPER_ALPHABET[i] ) }
              
            when :LABEL
              # do nothing
              rendered_items = element.items.map { |item| render( item, item_width ) }
              rendered_items.map! { |item| item.gsub( /\n/, "\n#{INDENT}" ) }

            when :NOTE
              alignment_width = element.items.flat_map(&:label).map(&:size).max + 1
              rendered_items = element.items.map { |item| render( item, item_width, alignment_width ) }
              rendered_items.map! { |item| item.gsub( /\n/, "\n#{INDENT}" ) }
          end

          "#{rendered_items.join( "\n\n" )}\n"

        else
          text = extract_text( element, width, alignment_width )
          styled_text = replace_markup( text )
          wrapped_text = wrap_to_width( styled_text, width )
          indent( wrapped_text )
      end
    end

    def self.extract_text( element, width, label_alignment_width = 0, conserve_newlines = false )
      text = case element
               when RDoc::Markup::Paragraph
                 join_char = conserve_newlines ? "\n" : " "
                 element.parts.map(&:strip).join( join_char )

               when RDoc::Markup::BlankLine
                 ""

               when RDoc::Markup::Rule
                 "-" * width

               when RDoc::Markup::Verbatim
                 element.parts.map { |part| part.prepend( "  " ) }.join

               when RDoc::Markup::Heading
                 "<h>#{element.text}</h>" 

               when RDoc::Markup::ListItem
                 parts = element.parts.map { |part| extract_text( part, width, 0, true ) }.join

                 if element.label
                   labels = element.label.map { |l| "#{l}:" }.join("\n")
                   sprintf( "%*s %s", -label_alignment_width, labels, parts )
                 else
                   parts
                 end

               when RDoc::Markup::List
                 render( element, width - INDENT_WIDTH )

                when RDoc::Markup::Document
                  element.parts.
                          map { |part| extract_text( part, width, label_alignment_width, conserve_newlines ) }.
                          join
               else  
                 raise "Don't know how to handle type #{element.class}: #{element.inspect}"
             end
      text << "\n"
    end

    def self.replace_markup( text )
      text.gsub!( /(?<!\\)<(?:tt|code)>/, Term::ANSIColor.cyan )
      text.gsub!( /(?<!\\)<\/(?:tt|code)>/, Term::ANSIColor.reset )

      text.gsub!( /(?<!\\)<b>/, Term::ANSIColor.bold )
      text.gsub!( /(?<!\\)<\/b>/, Term::ANSIColor.reset )

      text.gsub!( /(?<!\\)<(?:em|i)>/, Term::ANSIColor.yellow )
      text.gsub!( /(?<!\\)<\/(?:em|i)>/, Term::ANSIColor.reset )

      text.gsub!( "<h>", Term::ANSIColor.green )
      text.gsub!( "</h>", Term::ANSIColor.reset )

      text.gsub!( "\\<", "<" )

      text.gsub!( /(#\s*=>)(.*)/,
                  "#{Term::ANSIColor.dark}\\1#{Term::ANSIColor.reset}#{Term::ANSIColor.bold}\\2#{Term::ANSIColor.reset}" )

      text.gsub!( /(^|\s)\*(.*?[a-zA-Z0-9]+.*?)\*/, 
                  "\\1#{Term::ANSIColor.bold}\\2#{Term::ANSIColor.reset}" )
      text.gsub!( /(^|\s)\+(.*?[a-zA-Z0-9]+.*?)\+/, 
                  "\\1#{Term::ANSIColor.cyan}\\2#{Term::ANSIColor.reset}" )
      text.gsub!( /(^|\s)_(.*?[a-zA-Z0-9]+.*?)_/, 
                  "\\1#{Term::ANSIColor.yellow}\\2#{Term::ANSIColor.reset}" )

      text.gsub!( %r{\b((?:https?|ftp)://[-\w.?%&=/]+)\b}, 
                  "#{Term::ANSIColor.underline}\\1#{Term::ANSIColor.reset}" )

      text.gsub!( %r{\b(mailto:[-\w.%]+@[-\w.]+)\b}, 
                  "#{Term::ANSIColor.underline}\\1#{Term::ANSIColor.reset}" )

      text.gsub!( %r{\b((?<!:\/\/)www.[-\w.?%&=]+)\b}, 
                  "#{Term::ANSIColor.underline}\\1#{Term::ANSIColor.reset}" )

      text.gsub!( %r{\blink:(.*?)(\s|$)}, 
                  "#{Term::ANSIColor.underline}\\1#{Term::ANSIColor.reset}\\2" )

      text.gsub!( %r{\{(.*?)\}\[(.*?)\]}, "\\1 (\\2)" )
      text.gsub!( %r{\[(#{Regexp.escape( Term::ANSIColor.underline )}.*?#{Regexp.escape( Term::ANSIColor.reset )})\]}, 
                  " (\\1)" )
      text
    end

    def self.printable_length( text )
      Term::ANSIColor.uncolored( text ).length
    end

    def self.wrap_list( array, width = Bri.width )
      indent( wrap_to_width( array.join(" "), width ) )
    end

    def self.wrap_to_width( styled_text, width )
      styled_text.split( "\n" ).map { |row| wrap_row( row, width ) }.join
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
      text.split( "\n" ).map { |row| "#{INDENT}#{row}" }.join("\n" )
    end
  end
end
