module Bri
  module Renderer
    class List
      class Numbered < ::Bri::Renderer::Default
        def extract_text( width, label_alignment_width = 0, conserve_newlines = false )
          item_width = width - max_bullet_width
          rendered_items = element.items.each_with_index.
                                   map do |item, index| 
                                     ::Bri::Renderer.new( item ).text( item_width, 0, "#{index + 1}. " )
                                   end

          "#{rendered_items.join}\n\n"
        end

        def max_bullet_width
          ' 1. '.size
        end

        def bullet( item )
        end
      end
    end
  end
end
