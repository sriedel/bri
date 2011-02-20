require 'strscan'

module Bri
  module Renderer
    INDENT = ' ' * 2
    ALPHABET = ('a'..'z').to_a

    def self.render( element, width = Bri.width, alignment_width = 0 )
      # STDERR.puts "Rendering #{element.inspect}"
      case element
        when RDoc::Markup::Verbatim 
          text = extract_text( element, width )
          styled_text = replace_markup( text )
          indent( styled_text )

        when RDoc::Markup::List
          item_width = width - INDENT.length
          case element.type
            when :BULLET 
              rendered_items = element.items.collect { |item| render item, item_width }
              rendered_items.map! { |item| item.gsub( /\n/, "\n#{INDENT}" ) }
              rendered_items.map! { |item| ' *' + item }

            when :NUMBER
              i = 0
              rendered_items = element.items.collect { |item| render item, item_width }
              rendered_items.map! { |item| item.gsub( /\n/, "\n#{INDENT}" ) }
              rendered_items.map! { |item| i+=1; sprintf "%d.%s", i, item }

            when :LALPHA
              i = -1
              rendered_items = element.items.collect { |item| render item, item_width }
              rendered_items.map! { |item| item.gsub( /\n/, "\n#{INDENT}" ) }
              rendered_items.map! { |item| i+=1; sprintf "%s.%s", ALPHABET[i], item }
              
            when :LABEL
              # do nothing
              rendered_items = element.items.collect { |item| render item, item_width }
              rendered_items.map! { |item| item.gsub( /\n/, "\n#{INDENT}" ) }

            when :NOTE
              alignment_width = element.items.collect { |item| item.label.size }.max + 1
              rendered_items = element.items.collect { |item| render item, item_width, alignment_width }
              rendered_items.map! { |item| item.gsub( /\n/, "\n#{INDENT}" ) }
          end

          rendered_items.join( "\n\n" ) + "\n"

        else
          text = extract_text( element, width, alignment_width )
          styled_text = replace_markup( text )
          wrapped_text = wrap_to_width( styled_text, width )
          indent( wrapped_text )
      end
    end

    def self.extract_text( element, width, label_alignment_width = 0 )
      text = case element
               when RDoc::Markup::Paragraph 
                 element.parts.join( "\n" )
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
                 element.label ? sprintf( "%*s %s", -label_alignment_width, "#{element.label}:", parts ) : parts
               when RDoc::Markup::List
                 render( element, width - INDENT.length )
               else  
                 raise "Don't know how to handle type #{element.class}: #{element.inspect}"
             end
      text + "\n"
    end

    def self.replace_markup( text )
      text.gsub!( /(?<!\\)<(?:tt|code)>/, Term::ANSIColor::cyan )
      text.gsub!( /(?<!\\)<\/(?:tt|code)>/, Term::ANSIColor::reset )

      text.gsub!( /(?<!\\)<b>/, Term::ANSIColor::bold )
      text.gsub!( /(?<!\\)<\/b>/, Term::ANSIColor::reset )

      text.gsub!( /(?<!\\)<(?:em|i)>/, Term::ANSIColor::yellow )
      text.gsub!( /(?<!\\)<\/(?:em|i)>/, Term::ANSIColor::reset )

      text.gsub!( "<h>", Term::ANSIColor::green )
      text.gsub!( "</h>", Term::ANSIColor::reset )

      text.gsub!( "\\<", "<" )

      text.gsub!( /(^|\s)\*(.*?[a-zA-Z0-9]+.*?)\*/, 
                  "\\1#{Term::ANSIColor::bold}\\2#{Term::ANSIColor::reset}" )
      text.gsub!( /(^|\s)\+(.*?[a-zA-Z0-9]+.*?)\+/, 
                  "\\1#{Term::ANSIColor::cyan}\\2#{Term::ANSIColor::reset}" )
      text.gsub!( /(^|\s)_(.*?[a-zA-Z0-9]+.*?)_/, 
                  "\\1#{Term::ANSIColor::yellow}\\2#{Term::ANSIColor::reset}" )

      text.gsub!( %r{\b((?:https?|ftp)://[-\w.?%&=/]+)\b}, 
                  "#{Term::ANSIColor::underline}\\1#{Term::ANSIColor::reset}" )

      text.gsub!( %r{\b(mailto:[-\w.%]+@[-\w.]+)\b}, 
                  "#{Term::ANSIColor::underline}\\1#{Term::ANSIColor::reset}" )

      text.gsub!( %r{\b((?<!:\/\/)www.[-\w.?%&=]+)\b}, 
                  "#{Term::ANSIColor::underline}\\1#{Term::ANSIColor::reset}" )

      text.gsub!( %r{\blink:(.*?)(\s|$)}, 
                  "#{Term::ANSIColor::underline}\\1#{Term::ANSIColor::reset}\\2" )

      text.gsub!( %r{\{(.*?)\}\[(.*?)\]}, "\\1 (\\2)" )
      text.gsub!( %r{\[(#{Regexp.escape( Term::ANSIColor::underline )}.*?#{Regexp.escape( Term::ANSIColor::reset )})\]}, 
                  " (\\1)" )
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
