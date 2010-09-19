module Bri
  module Search
    class InstanceMethod < Method
      private
      def store_methods( store )
        store.instance_methods
      end

      def method_rdoc( store, klass = @class_term, method = @method_term )
        store.load_method( klass, "#" + method )
      end
    end
  end
end
