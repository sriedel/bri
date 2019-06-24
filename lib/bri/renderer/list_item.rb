module Bri
  module Renderer
    class ListItem < Default
      def text( total_width, bullet )
        element.parts.map.with_index do |part, index|
          part_is_list = part.is_a?(RDoc::Markup::List)

          text = ::Bri::Renderer.new( part ).extract_text( total_width, true )
          text.prepend( bullet ) if index == 0 && !part_is_list
          lines = text.lines
          first_line_indent = ( part_is_list || index > 0 ) ? bullet.size : 0
          following_line_indent = bullet.size
          [ indent( lines.first, indent_depth: first_line_indent ) ].concat( lines.drop( 1 ).map { |line| ( indent( line, indent_depth: following_line_indent ) ) } ).join
        end
      end
    end
  end
end
