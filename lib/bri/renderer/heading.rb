module Bri
  module Renderer
    class Heading < Default
      def self.extract_text( element, width, label_alignment_width = 0, conserve_newlines = false )
        "<h>#{element.text}</h>\n" 
      end
    end
  end
end
