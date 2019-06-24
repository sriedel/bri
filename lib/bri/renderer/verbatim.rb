module Bri
  module Renderer
    class Verbatim < Default
      def render( width = Bri.width )
        text = ::Bri::Renderer.extract_text( element, width )
        ::Bri::Renderer::Result.new( "#{text}\n", nil )
      end

      def extract_text( width, conserve_newlines = false )
        element.parts.map { |part| part.prepend( "  " ) }.join + "\n"
      end
    end
  end
end
