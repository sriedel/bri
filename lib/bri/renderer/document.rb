module Bri
  module Renderer
    class Document < Default
      def extract_text( width, label_alignment_width = 0, conserve_newlines = false )
         element.parts.
                 map { |part| ::Bri::Renderer.extract_text( part, width, label_alignment_width, conserve_newlines ) }.
                 join
      end
    end
  end
end
