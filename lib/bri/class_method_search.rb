module Bri
  class ClassMethodSearch
    attr_reader :term, :class_term, :method_term, :matches
    def initialize( term )
      @term = term
      @class_term, @method_term = term.split( /[\.#]/, 2 )
      @matches = []
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
