module Bri
  module Renderer
    class Document < Default
      def extract_text( width, conserve_newlines = false )
         element.parts.
                 map { |part| ::Bri::Renderer.extract_text( part, width, conserve_newlines ) }.
                 join
      end
    end
  end
end
