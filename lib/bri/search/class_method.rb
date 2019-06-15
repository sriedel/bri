module Bri
  module Search
    class ClassMethod < Method
      private
      def store_methods( store )
        store.class_methods
      end

      def method_rdoc( store, klass = @class_term, method = @method_term )
        store.load_method( klass, method )

      rescue Errno::ENOENT
        nil
      end
    end
  end
end
