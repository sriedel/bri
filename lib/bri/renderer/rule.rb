module Bri
  module Renderer
    class Rule < Default
      def extract_text( width, conserve_newlines = false )
        "-" * width + "\n"
      end
    end
  end
end
