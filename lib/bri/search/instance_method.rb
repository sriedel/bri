module Bri
  module Search
    class InstanceMethod < Method
      private
      def store_for_method
        Bri::Mall.instance.stores.detect do |store|
          store.instance_methods.has_key?( @class_term ) &&
          store.instance_methods[@class_term].include?( @method_term )
        end
      end

      def classes_with_method( store, method )
        store.instance_methods.
              select { |klass, methods| methods.include? method }.
              keys
      end

      def method_rdoc( store, klass = @class_term, method = @method_term )
        store.load_method( klass, "#" + method )
      end
    end
  end
end