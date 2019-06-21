module Bri
  module Renderer
    class Default
      attr_reader :element

      def initialize( element )
        @element = element
      end

      def render( width = Bri.width, alignment_width = 0 )
        text = extract_text( width, alignment_width )

        if text.empty?
          nil
        else
          ::Bri::Renderer::Result.new( text, width )
        end
      end

      def extract_text( width, label_alignment_width = 0, conserve_newslines = false )
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


      def self.wrap_list( array, width = Bri.width )
        indent( wrap_to_width( array.join("  "), width ) )
      end
    end
  end
end
