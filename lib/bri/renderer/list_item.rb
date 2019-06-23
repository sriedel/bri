module Bri
  module Renderer
    class ListItem < Default
      def extract_text( width, label_alignment_width = 0, conserve_newlines = false )
        # parts = element.parts.map { |part| ::Bri::Renderer.extract_text( part, width, 0, true ) }.join
        parts = element.parts.map do |part|
                  text = ::Bri::Renderer.extract_text( part, width, label_alignment_width, true )
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

      def text( total_width, block_indent, bullet )
        element.parts.map do |part|
          text = ::Bri::Renderer.extract_text( part, total_width, 0.size, true )
          text.prepend( bullet ) unless part.is_a?(RDoc::Markup::List)
          lines = text.lines
          first_line_indent = part.is_a?(RDoc::Markup::List) ? block_indent + bullet.size : block_indent
          following_line_indent = block_indent + bullet.size
          [" " * first_line_indent + lines.first].concat( lines.drop( 1 ).map { |line| ( " " * following_line_indent + line ) } ).join
        end
      end
    end
  end
end
