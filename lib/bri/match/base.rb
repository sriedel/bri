module Bri
  module Match
    class Base
      def to_s
        ERB.new( self.class.const_get( :TEMPLATE ), nil, '<>' ).
            result( binding )
      end

      private 
      def build_description( source )
        source.map { |element| Bri::Renderer.render element }
      end
    end
  end
end
