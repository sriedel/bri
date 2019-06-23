module Bri
  module Renderer
    class List
      class Note < ::Bri::Renderer::Default
        def render( width = Bri.width, alignment_width = 0 )
          item_width = width - max_bullet_width
          rendered_items = element.items.
                                   map do |item| 
                                     bullet = bullet( item )
                                     ::Bri::Renderer.new( item ).text( item_width, 0, bullet )
                                   end

          ::Bri::Renderer::Result.new( "#{rendered_items.join}\n", width )
        end

        def extract_text( width, label_alignment_width = 0, conserve_newlines = false )
          ::Bri::Renderer.render( element, width - ::Bri::Renderer::INDENT_WIDTH ).input + "\n"
        end

        def max_bullet_width
          element.items.flat_map(&:label).map(&:size).max
        end

        def bullet( item )
          "#{item.label.first}:" + " " * (max_bullet_width - item.label.first.size + 1)
        end
      end
    end
  end
end
