module Bri
  module Renderer
    class List
      class Bullet < ::Bri::Renderer::Default
        def render( width = Bri.width, alignment_width = 0 )
          item_width = width - 4
          rendered_items = element.items.
                                   map do |item| 
                                     rendered = ::Bri::Renderer.render( item, item_width, alignment_width + 2 )
                                     rendered.prepend( next_bullet )
                                     rendered
                                   end
          ::Bri::Renderer::Result.new( "#{rendered_items.map(&:input).join}\n", width )
        end

        def extract_text( width, label_alignment_width = 0, conserve_newlines = false )
          ::Bri::Renderer.render( element, width - ::Bri::Renderer::INDENT_WIDTH ).input + "\n"
        end

        def next_bullet
          '* '
        end
      end
    end
  end
end
