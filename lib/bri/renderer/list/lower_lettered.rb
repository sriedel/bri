module Bri
  module Renderer
    class List
      class LowerLettered < ::Bri::Renderer::Default
        LOWER_ALPHABET = ('a'..'z').to_a.freeze

        def render( width = Bri.width, alignment_width = 0 )
          item_width = width - max_bullet_width
          rendered_items = element.items.each_with_index.
                                   map do |item, index| 
                                     bullet = "#{LOWER_ALPHABET[index]}. " 
                                     ::Bri::Renderer.new( item ).text( item_width, 0, bullet )
                                   end

          ::Bri::Renderer::Result.new( "#{rendered_items.join}\n", width )
        end

        def extract_text( width, label_alignment_width = 0, conserve_newlines = false )
          ::Bri::Renderer.render( element, width - ::Bri::Renderer::INDENT_WIDTH ).input + "\n"
        end

        def max_bullet_width
          ' a. '.size
        end
      end
    end
  end
end
