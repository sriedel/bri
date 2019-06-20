module Bri
  module Renderer
    class BlankLine < Default
      def self.extract_text( element, width, label_alignment_width = 0, conserve_newlines = false )
        "\n"
      end
    end
  end
end
