module Bri
  module Search
    class ClassMethod < Base
      attr_reader :class_term, :method_term

      def initialize( term )
        super
        @class_term, @method_term = term.split( /[\.#]/, 2 )
      end

      def search( type = :fully_qualified )
        case type
          when :fully_qualified then fully_qualified_search
        end
      end

      private
      def fully_qualified_search
        store = Bri::Mall.instance.stores.detect do |store|
                  store.class_methods.has_key?( @class_term ) &&
                  store.class_methods[@class_term].include?( @method_term )
                end
        @matches << Bri::ClassMethodMatch.new( store.load_method( @class_term, 
                                                                  @method_term ) )
      end
    end
  end
end
