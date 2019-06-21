module Bri
  module Renderer
    class Rule < Default
      def extract_text( width, label_alignment_width = 0, conserve_newlines = false )
        "-" * width + "\n"
      end
    end
  end
end
