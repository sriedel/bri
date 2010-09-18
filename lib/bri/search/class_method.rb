module Bri
  module Search
    class ClassMethod < Method
      private
      def store_for_method
        Bri::Mall.instance.stores.detect do |store|
          store.class_methods.has_key?( @class_term ) &&
          store.class_methods[@class_term].include?( @method_term )
        end
      end

      def method_rdoc( store )
        store.load_method( @class_term, @method_term ) 
      end
    end
  end
end
