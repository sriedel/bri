module Bri
  module Renderer
    class Heading < Default
      def extract_text( width, conserve_newlines = false )
        "<h>#{element.text}</h>\n" 
      end
    end
  end
end
