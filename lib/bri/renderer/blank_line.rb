module Bri
  module Renderer
    class BlankLine < Default
      def extract_text( width, label_alignment_width = 0, conserve_newlines = false )
        "\n"
      end
    end
  end
end
