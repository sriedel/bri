module Bri
  module Renderer
    class Default
      Color = ::Term::ANSIColor

      def self.render( element, width = Bri.width, alignment_width = 0 )
        text = ::Bri::Renderer.extract_text( element, width, alignment_width )

        if text == "\n"
          nil
        else
          styled_text = replace_markup( text )
          wrapped_text = wrap_to_width( styled_text, width )
          indent( wrapped_text )
        end
      end

      def self.extract_text
        raise "Don't know how to handle type #{element.class}: #{element.inspect}"
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
        text.split( "\n" ).map { |row| "#{::Bri::Renderer::INDENT}#{row}" }.join("\n" )
      end

      def self.printable_length( text )
        Term::ANSIColor.uncolored( text ).length
      end

      def self.replace_markup( text )
        text.gsub!( /(?<!\\)<(?:tt|code)>/, Color.cyan )
        text.gsub!( /(?<!\\)<\/(?:tt|code)>/, Color.reset )

        text.gsub!( /(?<!\\)<b>/, Color.bold )
        text.gsub!( /(?<!\\)<\/b>/, Color.reset )

        text.gsub!( /(?<!\\)<(?:em|i)>/, Color.yellow )
        text.gsub!( /(?<!\\)<\/(?:em|i)>/, Color.reset )

        text.gsub!( "<h>", Color.green )
        text.gsub!( "</h>", Color.reset )

        text.gsub!( "\\<", "<" )

        text.gsub!( /(#\s*=>)(.*)/,
                    "#{Color.dark}\\1#{Color.reset}#{Color.bold}\\2#{Color.reset}" )

        text.gsub!( /(^|\s)\*(.*?[a-zA-Z0-9]+.*?)\*/, 
                    "\\1#{Color.bold}\\2#{Color.reset}" )
        text.gsub!( /(^|\s)\+(.*?[a-zA-Z0-9]+.*?)\+/, 
                    "\\1#{Color.cyan}\\2#{Color.reset}" )
        text.gsub!( /(^|\s)_(.*?[a-zA-Z0-9]+.*?)_/, 
                    "\\1#{Color.yellow}\\2#{Color.reset}" )

        text.gsub!( %r{\b((?:https?|ftp)://[-\w.?%&=/]+)\b}, 
                    "#{Color.underline}\\1#{Color.reset}" )

        text.gsub!( %r{\b(mailto:[-\w.%]+@[-\w.]+)\b}, 
                    "#{Color.underline}\\1#{Color.reset}" )

        text.gsub!( %r{\b((?<!:\/\/)www.[-\w.?%&=]+)\b}, 
                    "#{Color.underline}\\1#{Color.reset}" )

        text.gsub!( %r{\blink:(.*?)(\s|$)}, 
                    "#{Color.underline}\\1#{Color.reset}\\2" )

        text.gsub!( %r{\{(.*?)\}\[(.*?)\]}, "\\1 (\\2)" )
        text.gsub!( %r{\[(#{Regexp.escape( Color.underline )}.*?#{Regexp.escape( Color.reset )})\]}, 
                    " (\\1)" )
        text
      end

      def self.wrap_list( array, width = Bri.width )
        indent( wrap_to_width( array.join("  "), width ) )
      end
    end
  end
end
