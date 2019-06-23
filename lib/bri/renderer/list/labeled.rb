module Bri
  module Renderer
    class List
      class Labeled < ::Bri::Renderer::Default
        def extract_text( width, label_alignment_width = 0, conserve_newlines = false )
          item_width = width - max_bullet_width
          rendered_items = element.items.
                                   map do |item, index| 
                                    bullet = bullet( item )
                                     ::Bri::Renderer.new( item ).text( item_width, 0, bullet )
                                   end

          "#{rendered_items.join}\n\n"
        end

        def max_bullet_width
          element.items.map(&:label).map(&:size).max
        end

        def bullet( item )
          "#{item.label.first}: "
        end
      end
    end
  end
end
