module Bri
  module Renderer
    class Paragraph < Default
      def extract_text( width, label_alignment_width = 0, conserve_newlines = false )
        join_char = conserve_newlines ? "\n" : " "
        element.parts.map(&:strip).join( join_char ) + "\n"
      end
    end
  end
end
