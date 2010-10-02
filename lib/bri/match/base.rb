module Bri
  module Match
    class Base
      @@renderer = Bri::Renderer.new
      def to_s
        ERB.new( self.class.const_get( :TEMPLATE ), nil, '<>' ).
            result( binding )
      end

      private 
      def build_description( source )
        source.collect { |element| @@renderer.render element }
      end
    end
  end
end
