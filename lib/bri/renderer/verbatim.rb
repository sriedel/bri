module Bri
  module Renderer
    class Verbatim < Default
      def self.render( element, width = Bri.width, alignment_width = 0 )
        text = extract_text( element, width )
        styled_text = replace_markup( text )
        "#{indent( styled_text )}\n"
      end

      def self.extract_text( element, width, label_alignment_width = 0, conserve_newlines = false )
        element.parts.map { |part| part.prepend( "  " ) }.join + "\n"
      end
    end
  end
end
