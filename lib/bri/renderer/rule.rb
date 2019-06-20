module Bri
  module Renderer
    class Rule < Default
      def self.extract_text( element, width, label_alignment_width = 0, conserve_newlines = false )
        "-" * width + "\n"
      end
    end
  end
end
