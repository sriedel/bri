module Bri
  module Renderer
    class List < Default
      def self.new( element )
        case element.type
          when :BULLET then ::Bri::Renderer::List::Bullet.new( element )
          when :NUMBER then ::Bri::Renderer::List::Numbered.new( element )
          when :LALPHA then ::Bri::Renderer::List::LowerLettered.new( element )
          when :UALPHA then ::Bri::Renderer::List::UpperLettered.new( element )
          when :LABEL  then ::Bri::Renderer::List::Labeled.new( element )
          when :NOTE   then ::Bri::Renderer::List::Note.new( element )
        end
      end
    end
  end
end

require_relative 'list/base'
require_relative 'list/bullet'
require_relative 'list/numbered'
require_relative 'list/lower_lettered'
require_relative 'list/upper_lettered'
require_relative 'list/labeled'
require_relative 'list/note'
