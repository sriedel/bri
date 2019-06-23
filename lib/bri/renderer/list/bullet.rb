module Bri
  module Renderer
    class List
      class Bullet < ::Bri::Renderer::Default
        def render( width = Bri.width, alignment_width = 0 )
          item_width = width - max_bullet_width
          rendered_items = element.items.
                                   map do |item| 
                                     ::Bri::Renderer.new( item ).text( item_width, 0, bullet( item ) )
                                   end
          ::Bri::Renderer::Result.new( "#{rendered_items.join}\n", width )
        end

        def extract_text( width, label_alignment_width = 0, conserve_newlines = false )
          ::Bri::Renderer.render( element, width - ::Bri::Renderer::INDENT_WIDTH ).input + "\n"
        end

        def max_bullet_width
          ' * '.size
        end

        def bullet( item )
          '* '
        end
      end
    end
  end
end
