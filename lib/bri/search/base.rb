module Bri
  module Search
    class Base
      attr_reader :term, :matches

      def initialize( term )
        @term = term
        @matches = []
      end
    end
  end
end
