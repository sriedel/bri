module Bri
  module Renderer
    class List
      class Base < ::Bri::Renderer::Default
        def extract_text( width, label_alignment_width = 0, conserve_newlines = false )
          item_width = width - max_bullet_width
          rendered_items = element.items.each_with_index.
                                   map do |item, index|
                                     bullet = next_bullet( item )
                                     ::Bri::Renderer.new( item ).text( item_width, bullet )
                                   end

          "#{rendered_items.join}\n\n"
        end
      end
    end
  end
end
