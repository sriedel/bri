module Bri
  module Match
    class ClassMethod < Base
      include Bri::Templates::Helpers

      attr_accessor :full_name, :call_syntaxes, :description_paragraphs

      def initialize( rdoc_method )
        @full_name = rdoc_method.full_name
        @call_syntaxes = rdoc_method.call_seq.split( "\n" ).
                                              map { |e| "  " + e }.
                                              join( "\n" ) + "\n"
        @description_paragraphs = build_description( rdoc_method.comment.parts )
      end

      def to_s
        ERB.new( Bri::Templates::METHOD_DESCRIPTION, nil, '<>' ).result( binding )
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
