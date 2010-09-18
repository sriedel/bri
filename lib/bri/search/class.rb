module Bri
  module Search
    class Class < Base

      def search( type = :fully_qualified )
        # NOTE: classes are only searched as fully qualified for the time being
        # FIXME: What do we do if more than one store defines the same class?
        store = Bri::Mall.instance.stores.detect { |s| s.modules.include? @term }
        @matches << Bri::Match::Class.new( store.load_class( @term ) )
      end

    end
  end
end
