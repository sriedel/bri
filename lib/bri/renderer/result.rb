module Bri
  module Renderer
    class Result
      include ::Bri::TextFormattingUtils

      Color = ::Term::ANSIColor

      attr_reader :input, :width

      def initialize(input, width )
        @input = input
        @width = width
      end

      def output
        return @output if instance_variable_defined?( :@output )

        @output = replace_markup( input ).
                  then { |styled_text| width ? wrap_to_width( styled_text, width ) : styled_text }.
                  then { |wrapped_text| indent( wrapped_text ) }
      end

      def concat( other )
        output.concat( other.output )
      end

      def gsub( pattern, replacement )
        # TODO: make this function superfluous
        input.gsub!( pattern, replacement )
      end

      def prepend( prefix )
        input.prepend( prefix )
      end

      private

      def replace_markup( text )
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
    end
  end
end
