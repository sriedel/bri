module Bri
  module Renderer
    class ListItem < Default
      def extract_text( width, label_alignment_width = 0, conserve_newlines = false )
        parts = element.parts.map { |part| ::Bri::Renderer.extract_text( part, width, 0, true ) }.join

        if element.label
          labels = element.label.map { |l| "#{l}:" }.join("\n")
          sprintf( "%*s %s", -label_alignment_width, labels, parts )
        else
          parts
        end
      end
    end
  end
end
