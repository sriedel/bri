module Bri
  module Renderer
    class List < Default
      LOWER_ALPHABET = ('a'..'z').to_a.map { |char| "#{char}." }.freeze
      UPPER_ALPHABET = ('A'..'Z').to_a.map { |char| "#{char}." }.freeze

      def render( width = Bri.width, alignment_width = 0 )
        item_width = width - ::Bri::Renderer::INDENT_WIDTH
        rendered_items = case element.type
                           when :BULLET 
                             element.items.
                                     map do |item| 
                                       result = ::Bri::Renderer.render( item, item_width )
                                       result.gsub( /\n/, "\n#{::Bri::Renderer::INDENT}" )
                                       result.prepend( '* ' )
                                       result
                                     end
                           when :NUMBER
                             element.items.
                                     map do |item| 
                                       result = ::Bri::Renderer.render( item, item_width )
                                       result.gsub( /\n/, "\n#{::Bri::Renderer::INDENT}" )
                                       result.prepend( "#{i + 1}. " )
                                       result
                                     end

                           when :LALPHA
                             element.items.
                                     map do |item| 
                                       result = ::Bri::Renderer.render( item, item_width )
                                       result.gsub( /\n/, "\n#{::Bri::Renderer::INDENT}" )
                                       result.prepend( "#{LOWER_ALPHABET[i]} " )
                                       result
                                     end

                           when :UALPHA
                             element.items.
                                     map do |item| 
                                       result = ::Bri::Renderer.render( item, item_width )
                                       result.gsub( /\n/, "\n#{::Bri::Renderer::INDENT}" )
                                       result.prepend( "#{UPPER_ALPHABET[i]} " )
                                       result
                                     end
                             
                           when :LABEL
                             # do nothing
                             element.items.
                                     map do |item| 
                                       result = ::Bri::Renderer.render( item, item_width )
                                       result.gsub( /\n/, "\n#{::Bri::Renderer::INDENT}" )
                                       result
                                     end

                           when :NOTE
                             alignment_width = element.items.flat_map(&:label).map(&:size).max + 1
                             element.items.
                                     map do |item| 
                                       result = ::Bri::Renderer.render( item, item_width, alignment_width  )
                                       result.gsub( /\n/, "\n#{::Bri::Renderer::INDENT}" )
                                       result
                                     end
                         end

        ::Bri::Renderer::Result.new( "#{rendered_items.map(&:input).join( "\n" )}\n", width )
      end

      def extract_text( width, label_alignment_width = 0, conserve_newlines = false )
        ::Bri::Renderer.render( element, width - ::Bri::Renderer::INDENT_WIDTH ).input + "\n"
      end
    end
  end
end
