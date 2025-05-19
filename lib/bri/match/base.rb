module Bri
  module Match
    class Base
      def to_s
        ERB.new( self.class.const_get( :TEMPLATE ), trim_mode: '<>' ).
            result( binding )
      end

      private 
      def build_description_from_comment( comment )
        document = comment.instance_variable_get( :@document )
        build_description( document.parts )
      end

      def build_description( source )
        source.map { |element| Bri::Renderer.render( element ) }.compact
      end
    end
  end
end
