module Bri
  module Renderer
    class ListItem < Default
      def extract_text( width, label_alignment_width = 0, conserve_newlines = false )
        # parts = element.parts.map { |part| ::Bri::Renderer.extract_text( part, width, 0, true ) }.join
        parts = element.parts.map do |part|
                  text = ::Bri::Renderer.new( part ).render( width, label_alignment_width ).output
                  lines = text.lines
                  [lines.first].concat(lines.drop( 1 ).map { |line| (" " * label_alignment_width ) + line  }).join
                end


        # if element.label
        #   labels = element.label.map { |l| "#{l}:" }.join("\n")
        #   sprintf( "%*s %s", -label_alignment_width, labels, parts )
        # else
          parts
        # end
      end
    end
  end
end
