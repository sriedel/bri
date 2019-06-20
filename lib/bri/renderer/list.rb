module Bri
  module Renderer
    class List < Default
      LOWER_ALPHABET = ('a'..'z').to_a.map { |char| "#{char}." }.freeze
      UPPER_ALPHABET = ('A'..'Z').to_a.map { |char| "#{char}." }.freeze

      def self.render( element, width = Bri.width, alignment_width = 0 )
        item_width = width - ::Bri::Renderer::INDENT_WIDTH
        case element.type
          when :BULLET 
            rendered_items = element.items.map { |item| ::Bri::Renderer.render( item, item_width ) }
            rendered_items.map! { |item| item.gsub( /\n/, "\n#{::Bri::Renderer::INDENT}" ) }
            rendered_items.map! { |item| item.prepend( ' *' ) }

          when :NUMBER
            rendered_items = element.items.map { |item| ::Bri::Renderer.render( item, item_width ) }
            rendered_items.map! { |item| item.gsub( /\n/, "\n#{::Bri::Renderer::INDENT}" ) }
            rendered_items.map!.with_index( 1 ) { |item, i| item.prepend( "#{i}." ) }

          when :LALPHA
            rendered_items = element.items.map { |item| ::Bri::Renderer.render( item, item_width ) }
            rendered_items.map! { |item| item.gsub( /\n/, "\n#{::Bri::Renderer::INDENT}" ) }
            rendered_items.map!.with_index { |item, i| item.prepend( LOWER_ALPHABET[i] ) }

          when :UALPHA
            rendered_items = element.items.map { |item| ::Bri::Renderer.render( item, item_width ) }
            rendered_items.map! { |item| item.gsub( /\n/, "\n#{::Bri::Renderer::INDENT}" ) }
            rendered_items.map!.with_index { |item, index| item.prepend( UPPER_ALPHABET[i] ) }
            
          when :LABEL
            # do nothing
            rendered_items = element.items.map { |item| ::Bri::Renderer.render( item, item_width ) }
            rendered_items.map! { |item| item.gsub( /\n/, "\n#{::Bri::Renderer::INDENT}" ) }

          when :NOTE
            alignment_width = element.items.flat_map(&:label).map(&:size).max + 1
            rendered_items = element.items.map { |item| ::Bri::Renderer.render( item, item_width, alignment_width ) }
            rendered_items.map! { |item| item.gsub( /\n/, "\n#{::Bri::Renderer::INDENT}" ) }
        end

        "#{rendered_items.join( "\n" )}\n"
      end

      def self.extract_text( element, width, label_alignment_width = 0, conserve_newlines = false )
        ::Bri::Renderer.render( element, width - ::Bri::Renderer::INDENT_WIDTH ) + "\n"
      end
    end
  end
end
