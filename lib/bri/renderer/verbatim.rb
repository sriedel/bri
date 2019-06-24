module Bri
  module Renderer
    class Verbatim < Default
      def render( width = Bri.width )
        text = ::Bri::Renderer.new( element ).extract_text( width )
        ::Bri::Renderer::Result.new( "#{text}\n", nil )
      end

      def extract_text( width, conserve_newlines = false )
        element.parts.map { |part| indent(part) }.join + "\n"
      end
    end
  end
end
