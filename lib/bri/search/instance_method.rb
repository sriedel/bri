module Bri
  module Search
    class InstanceMethod < Method
      private
      def store_methods( store )
        store.instance_methods
      end

      def store_for_method
        Bri::Mall.instance.stores.detect do |store|
          store_methods( store ).has_key?( @class_term ) &&
          store_methods( store )[@class_term].include?( @method_term )
        end
      end

      def classes_with_method( store, method )
        store_methods( store ).select { |klass, methods| methods.include? method }.keys
      end

      def candidates_from_method_re( store, method_re )
        candidates = {}
        store_methods( store ).each do |klass, methods|
          matching_methods = methods.grep( method_re )
          next if matching_methods.empty?
          candidates[klass] = matching_methods
        end
        candidates
      end

      def method_rdoc( store, klass = @class_term, method = @method_term )
        store.load_method( klass, "#" + method )
      end
    end
  end
end
