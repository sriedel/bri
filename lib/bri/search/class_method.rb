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

      def classes_with_method( store, method )
        store.class_methods.
              select { |klass, methods| methods.include? method }.
              keys
      end

      def candidates_from_method_re( store, method_re )
        candidates = {}
        store.class_methods.each do |klass, methods|
          matching_methods = methods.grep( method_re )
          next if matching_methods.empty?
          candidates[klass] = matching_methods
        end
        candidates
      end

      def method_rdoc( store, klass = @class_term, method = @method_term )
        store.load_method( klass, method )
      end
    end
  end
end
