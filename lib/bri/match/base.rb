module Bri
  module Match
    class Base
      def to_s
        ERB.new( self.class.const_get( :TEMPLATE ), nil, '<>' ).
            result( binding )
      end

      private 
      def build_description( source )
        result = []
        source.each do |element|
          case element
            when RDoc::Markup::Paragraph 
              result << reflow( element.parts.join( " " ) )
            when RDoc::Markup::BlankLine
              result << ""
            when RDoc::Markup::Verbatim
              result << element.parts.join
            else  
              raise "Don't know how to handle type #{element.class}"
          end
        end
        result
      end

      def reflow( text, width = Bri::WIDTH )
        array_to_width( text.split( /\s+/ ), width, " ", 1 )
      end
    end
  end
end
