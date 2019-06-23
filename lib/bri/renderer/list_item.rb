module Bri
  module Renderer
    class ListItem < Default
      def text( total_width, bullet )
        element.parts.map do |part|
          text = ::Bri::Renderer.extract_text( part, total_width, 0.size, true )
          text.prepend( bullet ) unless part.is_a?(RDoc::Markup::List)
          lines = text.lines
          first_line_indent = part.is_a?(RDoc::Markup::List) ? bullet.size : 0
          following_line_indent = bullet.size
          [" " * first_line_indent + lines.first].concat( lines.drop( 1 ).map { |line| ( " " * following_line_indent + line ) } ).join
        end
      end
    end
  end
end
