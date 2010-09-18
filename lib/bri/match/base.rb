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
              result << reflow( element.text )
            when RDoc::Markup::BlankLine
              result << ""
            when RDoc::Markup::Verbatim
              result << element.text
            when RDoc::Markup::Heading
              result << '  ' * element.level + element.text
            when RDoc::Markup::ListItem
              result << "#{element.label} #{build_description( element.parts ).join}"
            when RDoc::Markup::List
              case element.type
                when :NOTE, :LABEL
                  result << "Note:"
                  result << build_description( element.items ).join( "\n" )
                when :BULLET
                  result << build_description( element.items ).join( "\n" )
                else 
                  raise "Don't know how to handle list type #{element.type}: #{element.inspect}"
              end
            else  
              raise "Don't know how to handle type #{element.class}: #{element.inspect}"
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
