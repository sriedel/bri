module Bri
  module Renderer
    class List
      class Bullet < ::Bri::Renderer::Default
        def extract_text( width, label_alignment_width = 0, conserve_newlines = false )
          item_width = width - max_bullet_width
          rendered_items = element.items.
                                   map do |item| 
                                     ::Bri::Renderer.new( item ).text( item_width, 0, bullet( item ) )
                                   end
          "#{rendered_items.join}\n\n"
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
