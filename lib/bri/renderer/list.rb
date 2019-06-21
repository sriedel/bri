module Bri
  module Renderer
    class List < Default
      LOWER_ALPHABET = ('a'..'z').to_a.map { |char| "#{char}." }.freeze
      UPPER_ALPHABET = ('A'..'Z').to_a.map { |char| "#{char}." }.freeze

      def render( width = Bri.width, alignment_width = 0 )
        item_width = width - ::Bri::Renderer::INDENT_WIDTH
        case element.type
          when :BULLET 
            rendered_items = element.items.map { |item| ::Bri::Renderer.render( item, item_width ) }
            rendered_items.each { |item| item.gsub( /\n/, "\n#{::Bri::Renderer::INDENT}" ) }
            rendered_items.each { |item| item.prepend( '* ' ) }

          when :NUMBER
            rendered_items = element.items.map { |item| ::Bri::Renderer.render( item, item_width ) }
            rendered_items.each { |item| item.gsub( /\n/, "\n#{::Bri::Renderer::INDENT}" ) }
            rendered_items.each_with_index { |item, i| item.prepend( "#{i + 1}. " ) }

          when :LALPHA
            rendered_items = element.items.map { |item| ::Bri::Renderer.render( item, item_width ) }
            rendered_items.each { |item| item.gsub( /\n/, "\n#{::Bri::Renderer::INDENT}" ) }
            rendered_items.each_with_index { |item, i| item.prepend( LOWER_ALPHABET[i]  + " ") }

          when :UALPHA
            rendered_items = element.items.map { |item| ::Bri::Renderer.render( item, item_width ) }
            rendered_items.each { |item| item.gsub( /\n/, "\n#{::Bri::Renderer::INDENT}" ) }
            rendered_items.each_with_index { |item, index| item.prepend( UPPER_ALPHABET[i]  + " ") }
            
          when :LABEL
            # do nothing
            rendered_items = element.items.map { |item| ::Bri::Renderer.render( item, item_width ) }
            rendered_items.each { |item| item.gsub( /\n/, "\n#{::Bri::Renderer::INDENT}" ) }

          when :NOTE
            alignment_width = element.items.flat_map(&:label).map(&:size).max + 1
            rendered_items = element.items.map { |item| ::Bri::Renderer.render( item, item_width, alignment_width ) }
            rendered_items.each { |item| item.gsub( /\n/, "\n#{::Bri::Renderer::INDENT}" ) }
        end

        ::Bri::Renderer::Result.new( "#{rendered_items.map(&:input).join( "\n" )}\n", width )
      end

      def extract_text( width, label_alignment_width = 0, conserve_newlines = false )
        ::Bri::Renderer.render( element, width - ::Bri::Renderer::INDENT_WIDTH ).input + "\n"
      end
    end
  end
end
