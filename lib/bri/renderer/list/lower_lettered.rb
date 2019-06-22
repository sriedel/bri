module Bri
  module Renderer
    class List
      class LowerLettered < ::Bri::Renderer::Default
        LOWER_ALPHABET = ('a'..'z').to_a.map { |char| "#{char}." }.freeze

        def render( width = Bri.width, alignment_width = 0 )
          item_width = width - ::Bri::Renderer::INDENT_WIDTH
          rendered_items = element.items.each_with_index.
                                   map do |item, index| 
                                     result = ::Bri::Renderer.render( item, item_width )
                                     result.gsub( /\n/, "\n#{::Bri::Renderer::INDENT}" )
                                     result.prepend( "#{LOWER_ALPHABET[index]} " )
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
