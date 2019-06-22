module Bri
  module Renderer
    class List
      class Note < ::Bri::Renderer::Default
        def render( width = Bri.width, alignment_width = 0 )
          item_width = width - ::Bri::Renderer::INDENT_WIDTH
          alignment_width = element.items.flat_map(&:label).map(&:size).max + 1

          rendered_items = element.items.
                                   map do |item| 
                                     result = ::Bri::Renderer.render( item, item_width, alignment_width  )
                                     result.gsub( /\n/, "\n#{::Bri::Renderer::INDENT}" )
                                     result
                                   end

          ::Bri::Renderer::Result.new( "#{rendered_items.map(&:input).join( "\n" )}\n", width )
        end

        def extract_text( width, label_alignment_width = 0, conserve_newlines = false )
          ::Bri::Renderer.render( element, width - ::Bri::Renderer::INDENT_WIDTH ).input + "\n"
        end
        
      end
    end
  end
end
