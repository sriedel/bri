module Bri
  module Renderer
    class BlankLine < Default
      def extract_text( width, conserve_newlines = false )
        "\n"
      end
    end
  end
end
