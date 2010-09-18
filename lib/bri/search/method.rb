module Bri
  module Search
    class Method < Base
      attr_reader :class_term, :method_term

      def initialize( term )
        super
        @class_term, @method_term = term.split( /[\.#]/, 2 )
      end

      def search( type = :fully_qualified )
        case type
          when :fully_qualified     then fully_qualified_search
          when :partially_qualified then partially_qualified_search
          when :unqualified         then unqualified_search
          else :error # TODO: Error handling
        end
      end

      private
      def fully_qualified_search
        @matches << Bri::Match::Method.new( method_rdoc( store_for_method ) )
      end

      def partially_qualified_search  
        Bri::Mall.instance.stores.each do |store|
          classes_with_method( store, @method_term ).each do |klass|
            @matches << Bri::Match::Method.new( method_rdoc( store, klass, @method_term ) )
          end
        end
      end

      def unqualified_search
        raise "Implement me!"
      end
    end
  end
end
