module Bri
  module Search
    class Class < Base
      def search( type = :fully_qualified )
        # NOTE: classes are only searched as fully qualified for the time being
        Bri::Mall.instance.stores.select { |s| s.module_names.include?( @term ) }.each do |store|
          @matches << Bri::Match::Class.new( store.load_class( @term ), store )
        end
      end
    end
  end
end
