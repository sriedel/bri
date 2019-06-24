module Bri
  module Renderer
    class Default
      include ::Bri::TextFormattingUtils

      attr_reader :element

      def initialize( element )
        @element = element
      end

      def render( width = Bri.width )
        text = extract_text( width )

        if text.empty?
          nil
        else
          ::Bri::Renderer::Result.new( text, width )
        end
      end

      def extract_text( width, conserve_newslines = false )
        raise "Don't know how to handle type #{element.class}: #{element.inspect}"
      end
    end
  end
end
